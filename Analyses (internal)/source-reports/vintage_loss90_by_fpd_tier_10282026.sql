WITH
issuance AS (
  SELECT user_id, DATE_TRUNC(DATE(MAX(date), 'Asia/Manila'), MONTH) AS cohort_month
  FROM `epicac-2.epicac_prod_direct.public_account_status_transitions`
  WHERE new_state = 'ApprovedAndIssued' GROUP BY user_id
),
base AS (
WITH
cards AS (
  SELECT id AS card_id, user_id FROM (
    SELECT id, user_id, datastream_metadata.change_type AS ct FROM `epicac-2.epicac_prod_direct.public_cards`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY datastream_metadata.source_timestamp DESC) = 1
  ) WHERE ct != 'DELETE'
),
i2c AS (
  SELECT c.user_id, p.sd, p.mt, p.tt, p.amt FROM (
    SELECT JSON_VALUE(data, '$.Transaction.TransactionId') AS tid,
           JSON_VALUE(data, '$.Card.CardReferenceID')     AS card_id,
           JSON_VALUE(data, '$.Transaction.MessageType')   AS mt,
           JSON_VALUE(data, '$.Transaction.TransactionType') AS tt,
           SAFE_CAST(JSON_VALUE(data, '$.Transaction.TransactionAmount') AS NUMERIC) AS amt,
           COALESCE(SAFE.PARSE_DATE('%Y-%m-%d', JSON_VALUE(data, '$.Transaction.SettlementDate')),
                    SAFE.PARSE_DATE('%Y-%m-%d', JSON_VALUE(data, '$.Transaction.Date')),
                    DATE(created_at)) AS sd
    FROM `epicac-2.epicac_prod_direct.public_i2c_web_push_messages`
    WHERE category = 'FinancialTransaction'
      AND JSON_VALUE(data, '$.Transaction.TransactionResponseCode') = '00'
      AND ((JSON_VALUE(data, '$.Transaction.MessageType') = '0220' AND JSON_VALUE(data, '$.Transaction.TransactionType') = '1Z')
        OR (JSON_VALUE(data, '$.Transaction.MessageType') IN ('0200','0400','0420') AND JSON_VALUE(data, '$.Transaction.TransactionType') = '21'))
    QUALIFY ROW_NUMBER() OVER (PARTITION BY tid ORDER BY created_at) = 1
  ) p JOIN cards c USING (card_id)
),
stmts AS (
  SELECT id, user_id, from_date, to_date, due_date,
         SAFE_CAST(total_charges_net_installments   AS NUMERIC) AS chg_net,
         SAFE_CAST(other_credits                    AS NUMERIC) AS other_credits,
         SAFE_CAST(interest_charged                 AS NUMERIC) AS interest,
         SAFE_CAST(fee_charged                      AS NUMERIC) AS fees,
         SAFE_CAST(installment_statement_interest   AS NUMERIC) AS inst_interest,
         SAFE_CAST(installment_statement_principal  AS NUMERIC) AS inst_principal_billed,
         SAFE_CAST(installment_principal_outstanding AS NUMERIC) AS inst_principal_outstanding,
         SAFE_CAST(total_payments                   AS NUMERIC) AS total_payments,
         SAFE_CAST(ending_balance                   AS NUMERIC) AS ending_balance
  FROM (
    SELECT *, datastream_metadata.change_type AS ct FROM `epicac-2.epicac_prod_direct.public_statements`
    QUALIFY ROW_NUMBER() OVER (
      PARTITION BY id
      ORDER BY datastream_metadata.source_timestamp DESC,
        LPAD(SPLIT(datastream_metadata.sort_keys[SAFE_OFFSET(1)], '/')[SAFE_OFFSET(0)], 8, '0') DESC,
        LPAD(SPLIT(datastream_metadata.sort_keys[SAFE_OFFSET(1)], '/')[SAFE_OFFSET(1)], 8, '0') DESC) = 1
  ) WHERE ct != 'DELETE'
),
stmt_flows AS (
  SELECT s.*,
    COALESCE((SELECT SUM(amt)  FROM i2c i WHERE i.user_id = s.user_id AND i.tt = '1Z' AND i.amt > 0 AND i.sd BETWEEN s.from_date AND s.to_date), 0) AS conversion_credits,
    COALESCE((SELECT SUM(-amt) FROM i2c i WHERE i.user_id = s.user_id AND i.tt = '1Z' AND i.amt < 0 AND i.sd BETWEEN s.from_date AND s.to_date), 0) AS cancellation_readds
  FROM stmts s
),
last_stmt AS (
  SELECT user_id, MAX(to_date) AS last_to_date FROM stmts GROUP BY user_id
),
cash_after_last AS (
  SELECT i.user_id, SUM(i.amt) AS cash_after
  FROM i2c i JOIN last_stmt l USING (user_id)
  WHERE i.tt = '21' AND i.sd > l.last_to_date
  GROUP BY i.user_id
),
monthly AS (
  SELECT user_id, DATE_TRUNC(to_date, MONTH) AS origination_month,
    GREATEST(0, SUM(chg_net - other_credits - cancellation_readds)) AS principal_originated,
    GREATEST(0, SUM(IF(due_date <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 16 DAY),
                       chg_net - other_credits - cancellation_readds, 0))) AS principal_originated_seasoned,
    GREATEST(0, SUM(IF(due_date <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 30 DAY),
                       chg_net - other_credits - cancellation_readds, 0))) AS principal_originated_seasoned30,
    GREATEST(0, SUM(IF(due_date <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 60 DAY),
                       chg_net - other_credits - cancellation_readds, 0))) AS principal_originated_seasoned60,
    GREATEST(0, SUM(IF(due_date <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 90 DAY),
                       chg_net - other_credits - cancellation_readds, 0))) AS principal_originated_seasoned90,
    SUM(chg_net)             AS gross_purchases,
    SUM(other_credits)       AS refunds_chargebacks,
    SUM(cancellation_readds) AS cancellation_readds,
    SUM(interest + fees + inst_interest) AS non_principal_originated,
    SUM(total_payments - conversion_credits) AS cash_paid,
    SUM(conversion_credits)  AS conversion_credits
  FROM stmt_flows GROUP BY 1, 2
),
user_cash AS (
  SELECT m.user_id, SUM(m.cash_paid) + COALESCE(MAX(c.cash_after), 0) AS total_cash
  FROM monthly m LEFT JOIN cash_after_last c USING (user_id) GROUP BY 1
),
tranches AS (
  SELECT user_id, origination_month, 'non_principal' AS tranche_type, non_principal_originated AS amount, 0 AS seq FROM monthly
  UNION ALL
  SELECT user_id, origination_month, 'principal', principal_originated, 1 FROM monthly
),
waterfall AS (
  SELECT t.user_id, t.origination_month, t.tranche_type, t.amount,
    SUM(t.amount) OVER (PARTITION BY t.user_id ORDER BY t.origination_month, t.seq
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_through,
    u.total_cash
  FROM tranches t JOIN user_cash u USING (user_id)
)
SELECT
  w.user_id,
  w.origination_month,
  w.tranche_type,
  ROUND(w.amount, 2)                                                            AS originated_php,
  ROUND(GREATEST(0, LEAST(w.amount, w.cum_through - w.total_cash)), 2)          AS remaining_php,
  ROUND(IF(w.tranche_type = 'principal', m.principal_originated_seasoned, 0), 2) AS originated_seasoned_php,
  ROUND(IF(w.tranche_type = 'principal', m.principal_originated_seasoned30, 0), 2) AS originated_seasoned30_php,
  ROUND(IF(w.tranche_type = 'principal', m.principal_originated_seasoned60, 0), 2) AS originated_seasoned60_php,
  ROUND(IF(w.tranche_type = 'principal', m.principal_originated_seasoned90, 0), 2) AS originated_seasoned90_php,
  m.gross_purchases, m.refunds_chargebacks, m.cancellation_readds, m.cash_paid, m.conversion_credits
FROM waterfall w
JOIN monthly m USING (user_id, origination_month)
),
delinq AS (
  SELECT user_id, days_past_due, DATE_SUB(effective_delinquency_date, INTERVAL days_past_due - 16 DAY) AS went_bad_on FROM (
    SELECT user_id, days_past_due, effective_delinquency_date, datastream_metadata.change_type AS ct
    FROM `epicac-2.epicac_prod_direct.public_delinquent_accounts`
    QUALIFY ROW_NUMBER() OVER (
      PARTITION BY user_id
      ORDER BY datastream_metadata.source_timestamp DESC,
        LPAD(SPLIT(datastream_metadata.sort_keys[SAFE_OFFSET(1)], '/')[SAFE_OFFSET(0)], 8, '0') DESC,
        LPAD(SPLIT(datastream_metadata.sort_keys[SAFE_OFFSET(1)], '/')[SAFE_OFFSET(1)], 8, '0') DESC) = 1
  ) WHERE ct != 'DELETE' AND days_past_due > 15
),
stmts AS (
  SELECT user_id, to_date, due_date FROM (
    SELECT id, user_id, to_date, due_date, datastream_metadata.change_type AS ct FROM `epicac-2.epicac_prod_direct.public_statements`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY datastream_metadata.source_timestamp DESC) = 1
  ) WHERE ct != 'DELETE'
),
first_stmt AS (SELECT user_id, MIN(to_date) AS first_to_date FROM stmts GROUP BY 1),
fpd AS (
  SELECT d.user_id, (s.to_date = f.first_to_date) AS is_fpd
  FROM delinq d JOIN stmts s USING (user_id) JOIN first_stmt f USING (user_id)
  QUALIFY ROW_NUMBER() OVER (PARTITION BY d.user_id ORDER BY ABS(DATE_DIFF(d.went_bad_on, s.due_date, DAY) - 16)) = 1
),
u AS (
  SELECT b.*, COALESCE(d.days_past_due, 0) AS dpd, COALESCE(f.is_fpd, FALSE) AS is_fpd
  FROM base b LEFT JOIN delinq d USING (user_id) LEFT JOIN fpd f USING (user_id)
),
t1 AS (SELECT user_id FROM UNNEST(['5d67575e-2c74-4aad-85f2-6a5b7b99d327','accf9b2d-f2f1-4bd2-aa63-9e504a6da1c1','0eef7feb-6940-4b7a-8cd9-f75a89d39748','4ccf6756-24dd-447d-be55-00b355a0579c','d2ace606-f4d3-4744-a045-5dcbcfbe4edd','cd64db52-8aa1-460f-844c-8f3446c69e06','da29bb06-a46b-4b4b-a1c6-f68e0bf48b93']) user_id),
t12 AS (SELECT user_id FROM UNNEST(['71a304f0-f868-49ef-80bb-8373c1d60acc','63ecdc4c-ab18-4981-b69e-c05b5e7360b9','b19c7041-37ea-4b75-bec2-023f895dfb0c','e4ab3bff-07ad-4127-9c62-648c1f2f2aed','b1e0e6fc-15f4-4bcc-91e0-0b4671ed32bc','e1b2987d-578a-4c9d-a12c-54e861895cef','2c4ecef1-3563-485a-bc0b-490f577ac0f0','8216d3e8-500e-43d1-af27-558adb008b47','e3b8e29e-6da6-484a-89ee-8b75e37d64f9','f493e25f-bf09-4639-9ed3-86ab58aa2b1c','9023fb70-d9b0-45d6-b61e-90c697ec8fde','309d5512-b879-4165-9ec6-b316f4d3d45f','f6d4ef24-c79d-4c85-9a90-2a60c92f8820','f79d09a0-dbe2-4661-858f-0262279a94ba','29210aa8-0650-421e-bc5d-08f230f4d59f','9b5f6588-cc14-450c-b30f-3083e3197e7c','9fac15f9-bd57-431d-826b-392b0edd556d','e14949bb-a290-4edc-bc7a-0509da46fa85','4fa178f7-aba7-446d-808f-defc53c08111','e458fe98-523d-4d50-9976-c155df9b8763','5206ec5e-35b9-401e-935a-9521e4bf5098','2f4ee969-68b3-4786-8f9f-abe5be765122','5d67575e-2c74-4aad-85f2-6a5b7b99d327','3fc0eac8-2e0a-485d-ab24-d1bdabd4e62c','73cd0723-1d6d-4566-b340-f21643aeb205','ca60689d-eba1-47db-8012-74f57b18bb32','bdb8ec06-549c-4e93-b46f-d3feba58ef95','c25d3136-f655-43fc-9828-9763c9c735a7','c75c47c4-13b4-406b-9473-3193190456f1','9861a751-4822-4e43-9c26-8e5869587838','6f8f5b33-a675-4242-840f-25d360af17f3','cb908f23-8870-458e-b1c9-0a1c211ec2c2','ada5d6a4-7032-469c-9d84-6efe3d97a4bd','accf9b2d-f2f1-4bd2-aa63-9e504a6da1c1','0eef7feb-6940-4b7a-8cd9-f75a89d39748','eed1cbcb-b19c-49c3-b4c4-becd86ed012f','4ccf6756-24dd-447d-be55-00b355a0579c','d2ace606-f4d3-4744-a045-5dcbcfbe4edd','cd64db52-8aa1-460f-844c-8f3446c69e06','da29bb06-a46b-4b4b-a1c6-f68e0bf48b93','fa2eb06f-36a9-48f6-b909-803c36c6560f','239365b3-9a57-46ed-8ffb-f12a251b6ad1']) user_id),
a89 AS (SELECT user_id FROM UNNEST(['71a304f0-f868-49ef-80bb-8373c1d60acc','63ecdc4c-ab18-4981-b69e-c05b5e7360b9','0f885594-d9da-4a1e-9058-2a34469d2937','b19c7041-37ea-4b75-bec2-023f895dfb0c','a0f561f6-e96b-4c22-9f32-cea061a14d2a','b1dec97e-8635-442c-b9ea-6c981fe7fa09','3ae853a5-af9f-49e9-ab1f-9c8c6b150a50','e4ab3bff-07ad-4127-9c62-648c1f2f2aed','b1e0e6fc-15f4-4bcc-91e0-0b4671ed32bc','1abcafa7-c43c-440e-8e89-1d4f7703ebb6','e1b2987d-578a-4c9d-a12c-54e861895cef','a73f12fd-ff17-4aee-baf1-0c699de6fe45','2c4ecef1-3563-485a-bc0b-490f577ac0f0','a51102eb-9008-4bcf-9c68-baf81f7baa13','efe5bd55-5357-4899-99ae-18dc41ee4e19','3d02eba4-7028-4d23-9711-55794d3f2b56','13cd75af-88e3-4dac-8a37-8a58c289183d','32d76df8-e800-4a48-b06b-f5492233ec73','38d3bf3c-e00f-42a2-bf23-4329f5399c9a','2c47aaf6-0f06-4c8c-b24b-8d7389f5d204','42cd37aa-fa57-4258-8beb-e4852b9a221e','eeefea08-7e2d-43f3-82e8-f299839b3e54','3aa1ad42-96d7-4afa-8661-c1ddf2b8f594','cfc84551-ed23-4de4-b5e1-967ecf96bc6a','99f63cdf-5aff-4a57-8b4d-62cef0497783','b073fd85-5afc-45c6-86dc-2fe76175ea72','8216d3e8-500e-43d1-af27-558adb008b47','e3b8e29e-6da6-484a-89ee-8b75e37d64f9','f493e25f-bf09-4639-9ed3-86ab58aa2b1c','1bd0d81d-45a2-4719-8f2f-4f85bf0e525e','02518ef8-864f-43bd-91a9-6093d5c66b2f','77355354-d078-4f1c-be46-cc8076eb9812','45b05715-5cc5-42bc-b598-2ea5a26817a5','e05b279b-4700-4560-9fd2-29c27f6f5a5b','9023fb70-d9b0-45d6-b61e-90c697ec8fde','2e8646ca-e276-48f2-967d-0bc98fe20cf2','309d5512-b879-4165-9ec6-b316f4d3d45f','5a02f248-22c2-4010-8d9c-d04ecdced536','7c9a1870-f144-4b48-9666-6a72406ad563','f6d4ef24-c79d-4c85-9a90-2a60c92f8820','03fa3f13-e822-4a5d-9287-2795ae4de656','ba5e1c88-f420-4474-ab3e-b123c987be61','ca68d5d3-933c-453d-b705-f6aba3f1185d','f79d09a0-dbe2-4661-858f-0262279a94ba','29210aa8-0650-421e-bc5d-08f230f4d59f','20d06d09-0dbb-4410-9c90-b9f8175df215','cd76e5f0-4a4c-4118-8d21-1772e60234c0','206de418-190d-445b-bdb7-75492c3d6f48','2d99f92a-4b1d-45fb-b680-ebde7f743044','4cfe39dc-2ecd-42bd-b1db-1e0c7449c37b','9b5f6588-cc14-450c-b30f-3083e3197e7c','c2553c5e-8867-42fa-bbf7-3798eb30f7e0','ad81364c-d138-46d8-9680-97e1a91ceab3','0574938b-b5df-4998-8a6a-fdcd02188a68','9fac15f9-bd57-431d-826b-392b0edd556d','e3c592d4-8251-4408-b871-81ca35b21469','e14949bb-a290-4edc-bc7a-0509da46fa85','2e67f79d-4d68-4f3b-9358-22c7e6ec8841','4fa178f7-aba7-446d-808f-defc53c08111','1a94b2a8-ea64-4eaf-9e72-e8d6fb24ac71','e458fe98-523d-4d50-9976-c155df9b8763','5206ec5e-35b9-401e-935a-9521e4bf5098','2f4ee969-68b3-4786-8f9f-abe5be765122','5d67575e-2c74-4aad-85f2-6a5b7b99d327','87ac96f8-92cd-4721-ad7a-dc0951cc975c','feab1d06-2a4a-4d87-85c0-4a64f6f4cf40','3fc0eac8-2e0a-485d-ab24-d1bdabd4e62c','73cd0723-1d6d-4566-b340-f21643aeb205','ca60689d-eba1-47db-8012-74f57b18bb32','bdb8ec06-549c-4e93-b46f-d3feba58ef95','c25d3136-f655-43fc-9828-9763c9c735a7','c75c47c4-13b4-406b-9473-3193190456f1','9861a751-4822-4e43-9c26-8e5869587838','6f8f5b33-a675-4242-840f-25d360af17f3','16b943d6-481a-479f-b05a-72f33fa66aef','ee909c83-68cb-4c1d-9687-e4ac7788e0c5','5b2c7add-cfdf-4144-a61b-50bcb2b17823','cb908f23-8870-458e-b1c9-0a1c211ec2c2','ada5d6a4-7032-469c-9d84-6efe3d97a4bd','accf9b2d-f2f1-4bd2-aa63-9e504a6da1c1','0eef7feb-6940-4b7a-8cd9-f75a89d39748','eed1cbcb-b19c-49c3-b4c4-becd86ed012f','4ccf6756-24dd-447d-be55-00b355a0579c','d2ace606-f4d3-4744-a045-5dcbcfbe4edd','cd64db52-8aa1-460f-844c-8f3446c69e06','da29bb06-a46b-4b4b-a1c6-f68e0bf48b93','5dd503ec-5190-4236-8a01-239fe57eef77','fa2eb06f-36a9-48f6-b909-803c36c6560f','239365b3-9a57-46ed-8ffb-f12a251b6ad1']) user_id),
agg AS (
  SELECT FORMAT_DATE('%Y-%m', origination_month) AS vintage,
    SUM(originated_seasoned90_php) s90, SUM(IF(dpd >= 90, remaining_php, 0)) d90,
    SUM(IF(NOT is_fpd, originated_seasoned90_php, 0)) s90x, SUM(IF(dpd >= 90 AND NOT is_fpd, remaining_php, 0)) d90x,
    SUM(IF(x1.user_id IS NULL, originated_seasoned90_php, 0)) s90_x1, SUM(IF(dpd >= 90 AND x1.user_id IS NULL, remaining_php, 0)) d90_x1,
    SUM(IF(x12.user_id IS NULL, originated_seasoned90_php, 0)) s90_x12, SUM(IF(dpd >= 90 AND x12.user_id IS NULL, remaining_php, 0)) d90_x12,
    SUM(IF(x89.user_id IS NULL, originated_seasoned90_php, 0)) s90_x89, SUM(IF(dpd >= 90 AND x89.user_id IS NULL, remaining_php, 0)) d90_x89,
    SUM(IF(dpd >= 90 AND x12.user_id IS NOT NULL, remaining_php, 0)) d90_t12, SUM(IF(dpd >= 90 AND x89.user_id IS NOT NULL, remaining_php, 0)) d90_89, SUM(IF(dpd >= 90 AND is_fpd, remaining_php, 0)) d90_fpd
  FROM u LEFT JOIN t1 x1 USING (user_id) LEFT JOIN t12 x12 USING (user_id) LEFT JOIN a89 x89 USING (user_id)
  WHERE tranche_type = 'principal' AND origination_month BETWEEN '2026-01-01' AND '2026-09-30' GROUP BY 1)
SELECT * FROM agg ORDER BY 1

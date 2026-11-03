WITH
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
    WHERE (category = 'FinancialTransaction'
      AND JSON_VALUE(data, '$.Transaction.TransactionResponseCode') = '00'
      AND ((JSON_VALUE(data, '$.Transaction.MessageType') = '0220' AND JSON_VALUE(data, '$.Transaction.TransactionType') = '1Z')
        OR (JSON_VALUE(data, '$.Transaction.MessageType') IN ('0200','0400','0420') AND JSON_VALUE(data, '$.Transaction.TransactionType') = '21')))
      OR (JSON_VALUE(data, '$.Transaction.MessageType') = '0220' AND JSON_VALUE(data, '$.Transaction.TransactionType') = 'LF')
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
    COALESCE((SELECT SUM(-amt) FROM i2c i WHERE i.user_id = s.user_id AND i.tt = '1Z' AND i.amt < 0 AND i.sd BETWEEN s.from_date AND s.to_date), 0) AS cancellation_readds,
    COALESCE((SELECT SUM(-amt) FROM i2c i WHERE i.user_id = s.user_id AND i.tt = 'LF' AND i.mt = '0220' AND i.amt < 0 AND i.sd BETWEEN s.from_date AND s.to_date), 0) AS lf_as_charge
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
    GREATEST(0, SUM(chg_net - other_credits - cancellation_readds - lf_as_charge)) AS principal_originated,
    GREATEST(0, SUM(IF(due_date <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 16 DAY),
                       chg_net - other_credits - cancellation_readds - lf_as_charge, 0))) AS principal_originated_seasoned,
    GREATEST(0, SUM(IF(due_date <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 30 DAY),
                       chg_net - other_credits - cancellation_readds - lf_as_charge, 0))) AS principal_originated_seasoned30,
    GREATEST(0, SUM(IF(due_date <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 60 DAY),
                       chg_net - other_credits - cancellation_readds - lf_as_charge, 0))) AS principal_originated_seasoned60,
    GREATEST(0, SUM(IF(due_date <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 90 DAY),
                       chg_net - other_credits - cancellation_readds - lf_as_charge, 0))) AS principal_originated_seasoned90,
    SUM(chg_net)             AS gross_purchases,
    SUM(other_credits)       AS refunds_chargebacks,
    SUM(cancellation_readds) AS cancellation_readds,
    SUM(interest + fees + inst_interest + lf_as_charge) AS non_principal_originated,
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
tiers AS (SELECT user_id, grp, tier, cohort FROM UNNEST([STRUCT<user_id STRING, grp STRING, tier STRING, cohort STRING>
('e552af2d-7ab3-4eb7-bace-f5a8c7472c9f','fraud','T2','pre-2026'),
('5ff51531-8227-4854-9a05-aa695c2c58a0','fraud','T2','pre-2026'),
('cda997e1-6bb3-4b78-b8cf-6d8957aa28ba','credit','T7','pre-2026'),
('a189c457-e1d5-4170-93e1-7885bbd78687','credit','T7','pre-2026'),
('8e6b504b-b21f-43af-8199-683931c5ccba','fraud','T2','pre-2026'),
('f71480bb-2e5d-4d50-aeaa-e9b5b6c79ab9','fraud','T2','pre-2026'),
('c8d96fff-9da6-4b46-9962-eed71fd34b37','fraud','T5','pre-2026'),
('64f00d2d-a7a7-4d14-b59c-8be90c1cc152','fraud','T2','pre-2026'),
('63f655bd-07c4-4efd-b1d6-733d8a219b60','credit','T6','pre-2026'),
('b9235e92-77ab-4d28-b94a-a0a630692cf7','credit','T7','pre-2026'),
('c2b52eff-74d1-42dd-9ec8-5fa24326e7c1','fraud','T3','pre-2026'),
('4b8607be-d02f-4f96-ad75-2c15be8f14fe','credit','T7','pre-2026'),
('8e002a02-af53-4197-8e48-9d66d71c4efd','fraud','T3','pre-2026'),
('ba8e4ffa-4a30-4a2e-b2fa-ceefac2538cb','fraud','T4','pre-2026'),
('be4275f2-3e31-4625-b63a-188e03f060ba','fraud','T2','pre-2026'),
('3c24679b-4a81-408f-84a6-95fdf9c649ce','fraud','T3','pre-2026'),
('e2495cc5-fbd6-477f-83db-93e13e7eea41','fraud','T3','pre-2026'),
('4f9dbdc3-3134-4c97-9b79-ff1dbdd9a1f1','credit','T7','pre-2026'),
('f957deb4-ce1f-424d-8966-66e4bdb979fc','fraud','T2','pre-2026'),
('2ba917d8-9a74-4ef7-963b-72290a46f701','fraud','T4','pre-2026'),
('44b8fa1d-d4a9-434a-9338-c82143381bcc','fraud','T2','pre-2026'),
('d6285ed5-4123-4a9f-a9eb-ad5795aca108','fraud','T2','pre-2026'),
('721d222d-e0da-4f03-95b5-5786695c8d25','fraud','T2','pre-2026'),
('56a4f0e5-0a3d-4d8c-91ee-b169462e842b','fraud','T2','pre-2026'),
('f07947d7-4c5c-47ad-a276-73dd7d112953','fraud','T2','pre-2026'),
('31b50733-24b3-46f9-a7e6-ffa707006b44','fraud','T2','pre-2026'),
('50f15576-00e8-46c4-878b-e560b5fb1917','fraud','T2','pre-2026'),
('d304904e-c6ae-486a-890e-a44ec6561046','fraud','T2','pre-2026'),
('af6084bb-9782-424d-bb1a-dbfc4685e46d','credit','T6','pre-2026'),
('faf237d3-ad4a-4934-8143-edb8e3937ed0','credit','T7','pre-2026'),
('0551ac71-1606-4fd7-a296-351d7cee852c','fraud','T3','pre-2026'),
('802f3a0c-190e-4fef-94b2-75031acddb50','fraud','T2','pre-2026'),
('417f6c9f-738f-429d-a885-be1f1d76f2ad','fraud','T2','pre-2026'),
('e8ae70e3-d658-415d-9ede-1cebb9495dcb','fraud','T2','pre-2026'),
('9b3905d5-7814-4b3d-bbd7-694cd2f51648','credit','T7','pre-2026'),
('25e9629d-4b52-41b5-a9d1-adfbddadc8d5','fraud','T3','pre-2026'),
('4e9da389-6dfe-4108-9d46-22ff9e42673b','fraud','T5','pre-2026'),
('af3eba50-6d28-40e9-97f0-916fd3426cad','credit','T7','pre-2026'),
('349b5c06-98f8-4c8a-a9d7-acb27a16ea98','fraud','T5','pre-2026'),
('c4c35ba4-8cb0-4c0d-abfe-471e99c70f99','fraud','T2','pre-2026'),
('d3af3988-d34b-4c6f-8b50-25e6117d899d','fraud','T2','pre-2026'),
('49b065d9-89d1-48d6-8558-79ef94dd940a','fraud','T2','pre-2026'),
('f8838d47-15b1-4602-99f3-87c112fccbd6','fraud','T3','pre-2026'),
('77c5b676-e1a1-465c-8a20-a41f6da3ba72','credit','T8','pre-2026'),
('7f741d0f-0063-4c57-97f2-c913a034fc9a','credit','T8','pre-2026'),
('a8310d1c-44d2-4357-b62c-ce9e01fd83e9','fraud','T2','pre-2026'),
('01a54d48-7ade-4995-8147-8006e3f8aa0e','fraud','T2','pre-2026'),
('94701bf8-a67c-4c69-848c-aaa3d246492a','fraud','T2','pre-2026'),
('e55447de-cfaf-41f0-ab43-462bf1634d9c','fraud','T2','pre-2026'),
('dc411187-f90d-49c4-9ab8-b7718bb562cb','fraud','T2','pre-2026'),
('7dce203e-6a79-47cd-9dfb-0c776532abb6','fraud','T2','pre-2026'),
('a027275d-b2c2-4b98-88e0-94ea8d9a12d7','fraud','T2','pre-2026'),
('3c1d6839-3ade-4803-a83d-3241be37995d','fraud','T2','pre-2026'),
('9b173c56-ccb4-4640-b846-52d598a18efe','fraud','T2','pre-2026'),
('fbc3b8fa-ecf6-47e3-9a00-583531ea853d','credit','T6','pre-2026'),
('8808fbcb-a09e-4178-b2c6-f04e98af5884','fraud','T2','pre-2026'),
('3bf4e8e7-7543-468e-8c2a-d9fd1eac377c','fraud','T2','pre-2026'),
('e06decde-b8c1-465f-b5a5-78c9534341be','credit','T7','pre-2026'),
('3db632f2-492f-41b5-82cf-42e75c62f1cc','fraud','T2','pre-2026'),
('26d903a7-e797-49dd-8596-df84d1e50e31','fraud','T3','pre-2026'),
('5b9d2446-ea4f-4ddf-8daa-0113822a564a','credit','T6','pre-2026'),
('4d1ee3c9-2c82-4355-b4d6-fde02e7f4012','fraud','T2','pre-2026'),
('25bfa174-13ca-4a03-bd00-748d8011dde4','fraud','T2','pre-2026'),
('1be23f93-4ffa-4954-a2d3-3552e466bca2','fraud','T2','pre-2026'),
('8c8b63f8-3d30-47e2-92fb-5089abf475f5','fraud','T2','pre-2026'),
('017d3461-c420-48e4-a0f8-55f386267cad','fraud','T2','pre-2026'),
('e08afc17-1e40-486c-b3a1-049b027d5d78','fraud','T3','pre-2026'),
('19ad5658-accf-4c1d-963f-4671ed65e713','credit','T8','pre-2026'),
('6cd7289b-938c-4380-9a61-d9d3f2bd8264','fraud','T3','pre-2026'),
('18180faa-d4eb-446d-a167-ec171d19fc8a','fraud','T2','pre-2026'),
('b67026c9-02b9-4304-bea4-9321eaa9f7f0','fraud','T5','pre-2026'),
('61230944-907e-4eb6-b184-c4a8e0eec911','fraud','T3','pre-2026'),
('588aed68-ae33-4718-937a-2eae7ff93928','fraud','T2','pre-2026'),
('328dc30b-667e-4065-9d26-7633145f7148','fraud','T2','pre-2026'),
('e38a6fcc-8dec-4066-8655-c8c5f792aeb6','credit','T8','pre-2026'),
('745c45bd-6c05-41cf-8a2e-707c15dd06c0','fraud','T2','pre-2026'),
('459d30ae-4480-4550-9fe5-33b6116aa366','credit','T7','pre-2026'),
('c176c281-6a14-4543-b12b-bef6995339e5','fraud','T2','pre-2026'),
('b66ea6fa-f8ea-4038-8d93-ae9ec3ce6839','fraud','T2','pre-2026'),
('71a304f0-f868-49ef-80bb-8373c1d60acc','fraud','T2','2026 pre-v2.1'),
('63ecdc4c-ab18-4981-b69e-c05b5e7360b9','fraud','T2','2026 pre-v2.1'),
('0f885594-d9da-4a1e-9058-2a34469d2937','fraud','T3','2026 pre-v2.1'),
('b19c7041-37ea-4b75-bec2-023f895dfb0c','fraud','T2','2026 pre-v2.1'),
('a0f561f6-e96b-4c22-9f32-cea061a14d2a','credit','T7','2026 pre-v2.1'),
('b1dec97e-8635-442c-b9ea-6c981fe7fa09','fraud','T3','2026 pre-v2.1'),
('3ae853a5-af9f-49e9-ab1f-9c8c6b150a50','credit','T6','2026 pre-v2.1'),
('b1e0e6fc-15f4-4bcc-91e0-0b4671ed32bc','fraud','T2','2026 pre-v2.1'),
('e4ab3bff-07ad-4127-9c62-648c1f2f2aed','fraud','T2','2026 pre-v2.1'),
('e1b2987d-578a-4c9d-a12c-54e861895cef','fraud','T2','2026 pre-v2.1'),
('1abcafa7-c43c-440e-8e89-1d4f7703ebb6','credit','T6','2026 pre-v2.1'),
('a73f12fd-ff17-4aee-baf1-0c699de6fe45','fraud','T5','2026 pre-v2.1'),
('efe5bd55-5357-4899-99ae-18dc41ee4e19','credit','T8','2026 pre-v2.1'),
('2c4ecef1-3563-485a-bc0b-490f577ac0f0','fraud','T2','2026 pre-v2.1'),
('3d02eba4-7028-4d23-9711-55794d3f2b56','credit','T8','2026 pre-v2.1'),
('a51102eb-9008-4bcf-9c68-baf81f7baa13','fraud','T5','2026 pre-v2.1'),
('13cd75af-88e3-4dac-8a37-8a58c289183d','credit','T7','2026 pre-v2.1'),
('32d76df8-e800-4a48-b06b-f5492233ec73','fraud','T3','2026 pre-v2.1'),
('38d3bf3c-e00f-42a2-bf23-4329f5399c9a','credit','T8','2026 pre-v2.1'),
('2c47aaf6-0f06-4c8c-b24b-8d7389f5d204','credit','T8','2026 pre-v2.1'),
('42cd37aa-fa57-4258-8beb-e4852b9a221e','credit','T6','2026 pre-v2.1'),
('eeefea08-7e2d-43f3-82e8-f299839b3e54','credit','T8','2026 pre-v2.1'),
('3aa1ad42-96d7-4afa-8661-c1ddf2b8f594','credit','T7','2026 pre-v2.1'),
('cfc84551-ed23-4de4-b5e1-967ecf96bc6a','fraud','T3','2026 pre-v2.1'),
('99f63cdf-5aff-4a57-8b4d-62cef0497783','credit','T8','2026 pre-v2.1'),
('b073fd85-5afc-45c6-86dc-2fe76175ea72','fraud','T3','2026 pre-v2.1'),
('8216d3e8-500e-43d1-af27-558adb008b47','fraud','T2','2026 pre-v2.1'),
('e3b8e29e-6da6-484a-89ee-8b75e37d64f9','fraud','T2','2026 pre-v2.1'),
('f493e25f-bf09-4639-9ed3-86ab58aa2b1c','fraud','T2','2026 pre-v2.1'),
('1bd0d81d-45a2-4719-8f2f-4f85bf0e525e','credit','T8','2026 pre-v2.1'),
('e05b279b-4700-4560-9fd2-29c27f6f5a5b','fraud','T4','2026 pre-v2.1'),
('02518ef8-864f-43bd-91a9-6093d5c66b2f','fraud','T3','2026 pre-v2.1'),
('77355354-d078-4f1c-be46-cc8076eb9812','credit','T7','2026 pre-v2.1'),
('45b05715-5cc5-42bc-b598-2ea5a26817a5','fraud','T4','2026 pre-v2.1'),
('9023fb70-d9b0-45d6-b61e-90c697ec8fde','fraud','T2','2026 pre-v2.1'),
('2e8646ca-e276-48f2-967d-0bc98fe20cf2','credit','T7','2026 pre-v2.1'),
('309d5512-b879-4165-9ec6-b316f4d3d45f','fraud','T2','2026 pre-v2.1'),
('5a02f248-22c2-4010-8d9c-d04ecdced536','credit','T8','2026 pre-v2.1'),
('7c9a1870-f144-4b48-9666-6a72406ad563','credit','T8','2026 pre-v2.1'),
('ca68d5d3-933c-453d-b705-f6aba3f1185d','credit','T7','2026 pre-v2.1'),
('03fa3f13-e822-4a5d-9287-2795ae4de656','credit','T8','2026 pre-v2.1'),
('f6d4ef24-c79d-4c85-9a90-2a60c92f8820','fraud','T2','2026 pre-v2.1'),
('ba5e1c88-f420-4474-ab3e-b123c987be61','credit','T6','2026 pre-v2.1'),
('f79d09a0-dbe2-4661-858f-0262279a94ba','fraud','T2','2026 pre-v2.1'),
('2d99f92a-4b1d-45fb-b680-ebde7f743044','credit','T8','2026 pre-v2.1'),
('206de418-190d-445b-bdb7-75492c3d6f48','fraud','T4','2026 pre-v2.1'),
('29210aa8-0650-421e-bc5d-08f230f4d59f','fraud','T2','2026 pre-v2.1'),
('4cfe39dc-2ecd-42bd-b1db-1e0c7449c37b','fraud','T3','2026 pre-v2.1'),
('cd76e5f0-4a4c-4118-8d21-1772e60234c0','fraud','T3','2026 pre-v2.1'),
('20d06d09-0dbb-4410-9c90-b9f8175df215','credit','T8','2026 pre-v2.1'),
('e3c592d4-8251-4408-b871-81ca35b21469','fraud','T3','2026 pre-v2.1'),
('ad81364c-d138-46d8-9680-97e1a91ceab3','fraud','T3','2026 pre-v2.1'),
('9b5f6588-cc14-450c-b30f-3083e3197e7c','fraud','T2','2026 pre-v2.1'),
('c2553c5e-8867-42fa-bbf7-3798eb30f7e0','fraud','T3','2026 pre-v2.1'),
('0574938b-b5df-4998-8a6a-fdcd02188a68','credit','T7','2026 pre-v2.1'),
('9fac15f9-bd57-431d-826b-392b0edd556d','fraud','T2','2026 pre-v2.1'),
('e14949bb-a290-4edc-bc7a-0509da46fa85','fraud','T2','2026 pre-v2.1'),
('2e67f79d-4d68-4f3b-9358-22c7e6ec8841','credit','T7','2026 pre-v2.1'),
('4fa178f7-aba7-446d-808f-defc53c08111','fraud','T2','2026 pre-v2.1'),
('1a94b2a8-ea64-4eaf-9e72-e8d6fb24ac71','fraud','T3','2026 pre-v2.1'),
('e458fe98-523d-4d50-9976-c155df9b8763','fraud','T2','2026 pre-v2.1'),
('5206ec5e-35b9-401e-935a-9521e4bf5098','fraud','T2','2026 pre-v2.1'),
('2f4ee969-68b3-4786-8f9f-abe5be765122','fraud','T2','2026 pre-v2.1'),
('5d67575e-2c74-4aad-85f2-6a5b7b99d327','ring','T1','2026 post-v2.1'),
('87ac96f8-92cd-4721-ad7a-dc0951cc975c','fraud','T4','2026 post-v2.1'),
('ca60689d-eba1-47db-8012-74f57b18bb32','fraud','T2','2026 post-v2.1'),
('feab1d06-2a4a-4d87-85c0-4a64f6f4cf40','credit','T8','2026 post-v2.1'),
('73cd0723-1d6d-4566-b340-f21643aeb205','fraud','T2','2026 post-v2.1'),
('3fc0eac8-2e0a-485d-ab24-d1bdabd4e62c','fraud','T2','2026 post-v2.1'),
('bdb8ec06-549c-4e93-b46f-d3feba58ef95','fraud','T2','2026 post-v2.1'),
('c25d3136-f655-43fc-9828-9763c9c735a7','fraud','T2','2026 post-v2.1'),
('c75c47c4-13b4-406b-9473-3193190456f1','fraud','T2','2026 post-v2.1'),
('9861a751-4822-4e43-9c26-8e5869587838','fraud','T2','2026 post-v2.1'),
('6f8f5b33-a675-4242-840f-25d360af17f3','fraud','T2','2026 post-v2.1'),
('ee909c83-68cb-4c1d-9687-e4ac7788e0c5','credit','T6','2026 post-v2.1'),
('5b2c7add-cfdf-4144-a61b-50bcb2b17823','fraud','T3','2026 post-v2.1'),
('16b943d6-481a-479f-b05a-72f33fa66aef','credit','T6','2026 post-v2.1'),
('ada5d6a4-7032-469c-9d84-6efe3d97a4bd','fraud','T2','2026 post-v2.1'),
('cb908f23-8870-458e-b1c9-0a1c211ec2c2','fraud','T2','2026 post-v2.1'),
('accf9b2d-f2f1-4bd2-aa63-9e504a6da1c1','ring','T1','2026 post-v2.1'),
('0eef7feb-6940-4b7a-8cd9-f75a89d39748','ring','T1','2026 post-v2.1'),
('cd64db52-8aa1-460f-844c-8f3446c69e06','ring','T1','2026 post-v2.1'),
('d2ace606-f4d3-4744-a045-5dcbcfbe4edd','ring','T1','2026 post-v2.1'),
('4ccf6756-24dd-447d-be55-00b355a0579c','ring','T1','2026 post-v2.1'),
('eed1cbcb-b19c-49c3-b4c4-becd86ed012f','fraud','T2','2026 post-v2.1'),
('da29bb06-a46b-4b4b-a1c6-f68e0bf48b93','ring','T1','2026 post-v2.1'),
('5dd503ec-5190-4236-8a01-239fe57eef77','fraud','T3','2026 post-v2.1'),
('fa2eb06f-36a9-48f6-b909-803c36c6560f','fraud','T2','2026 post-v2.1'),
('239365b3-9a57-46ed-8ffb-f12a251b6ad1','fraud','T2','2026 post-v2.1')]) ),
agg AS (
  SELECT FORMAT_DATE('%Y-%m', origination_month) AS vintage,
    SUM(originated_seasoned90_php) s90, SUM(IF(NOT is_fpd, originated_seasoned90_php, 0)) s90x,
    SUM(IF(is_fpd AND t.grp='ring', originated_seasoned90_php, 0)) s90_ring, SUM(IF(is_fpd AND t.grp='fraud', originated_seasoned90_php, 0)) s90_fraud, SUM(IF(is_fpd AND t.grp='credit', originated_seasoned90_php, 0)) s90_credit,
    SUM(IF(dpd >= 90, remaining_php, 0)) d90, SUM(IF(dpd >= 90 AND NOT is_fpd, remaining_php, 0)) d90x,
    SUM(IF(dpd >= 90 AND is_fpd, remaining_php, 0)) d90_fpd,
    SUM(IF(dpd >= 90 AND is_fpd AND t.grp = 'ring', remaining_php, 0)) d90_ring,
    SUM(IF(dpd >= 90 AND is_fpd AND t.grp = 'fraud', remaining_php, 0)) d90_fraud,
    SUM(IF(dpd >= 90 AND is_fpd AND t.grp = 'credit', remaining_php, 0)) d90_credit,
    SUM(IF(dpd >= 90 AND is_fpd AND t.grp IS NULL, remaining_php, 0)) d90_untiered,
    SUM(IF(dpd > 15, remaining_php, 0)) d16, SUM(IF(dpd > 15 AND NOT is_fpd, remaining_php, 0)) d16x,
    SUM(IF(dpd > 15 AND is_fpd, remaining_php, 0)) d16_fpd,
    SUM(IF(dpd > 15 AND is_fpd AND t.grp = 'ring', remaining_php, 0)) d16_ring,
    SUM(IF(dpd > 15 AND is_fpd AND t.grp = 'fraud', remaining_php, 0)) d16_fraud,
    SUM(IF(dpd > 15 AND is_fpd AND t.grp = 'credit', remaining_php, 0)) d16_credit,
    SUM(IF(dpd > 15 AND is_fpd AND t.grp IS NULL, remaining_php, 0)) d16_untiered,
    SUM(IF(dpd > 15 AND NOT is_fpd AND t.grp IN ('ring','fraud'), remaining_php, 0)) d16_fraud_not_fpd
  FROM u LEFT JOIN tiers t USING (user_id)
  WHERE tranche_type = 'principal' AND origination_month BETWEEN '2026-01-01' AND '2026-09-30' GROUP BY 1),
untiered AS (
  SELECT u.user_id, MIN(origination_month) first_vintage, ROUND(SUM(IF(dpd > 15, remaining_php, 0)),2) d16, MAX(dpd) dpd
  FROM u LEFT JOIN tiers t USING (user_id)
  WHERE tranche_type='principal' AND origination_month BETWEEN '2026-01-01' AND '2026-09-30' AND is_fpd AND dpd > 15 AND t.grp IS NULL
  GROUP BY 1 HAVING d16 > 0)
SELECT * FROM agg ORDER BY 1

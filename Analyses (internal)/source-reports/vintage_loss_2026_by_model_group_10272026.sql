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
agg AS (
  SELECT FORMAT_DATE('%Y-%m', origination_month) AS vintage,
    CASE WHEN i.cohort_month >= '2026-04-01' THEN 'c_apr26_on' WHEN i.cohort_month >= '2026-01-01' THEN 'b_jan_mar26' WHEN i.cohort_month IS NULL THEN 'unknown' ELSE 'a_pre2026' END AS grp,
    COUNT(DISTINCT u.user_id) accounts, SUM(originated_php) orig, SUM(originated_seasoned_php) s16, SUM(originated_seasoned90_php) s90,
    SUM(IF(NOT is_fpd, originated_seasoned_php, 0)) s16x, SUM(IF(NOT is_fpd, originated_seasoned90_php, 0)) s90x,
    SUM(IF(dpd > 15, remaining_php, 0)) d16, SUM(IF(dpd > 15 AND NOT is_fpd, remaining_php, 0)) d16x,
    SUM(IF(dpd >= 90, remaining_php, 0)) d90, SUM(IF(dpd >= 90 AND NOT is_fpd, remaining_php, 0)) d90x
  FROM u LEFT JOIN issuance i USING (user_id) WHERE tranche_type = 'principal' AND origination_month >= '2026-01-01' GROUP BY 1,2)
SELECT * FROM agg ORDER BY 1,2

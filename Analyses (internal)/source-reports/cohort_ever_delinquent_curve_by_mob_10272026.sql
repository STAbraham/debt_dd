WITH issuance AS (
  SELECT user_id, DATE_TRUNC(DATE(MAX(date), 'Asia/Manila'), MONTH) AS cohort_month
  FROM `epicac-2.epicac_prod_direct.public_account_status_transitions` WHERE new_state = 'ApprovedAndIssued' GROUP BY user_id),
hist AS (
  SELECT user_id,
    MIN(IF(days_past_due > 15, DATE_SUB(effective_delinquency_date, INTERVAL days_past_due - 16 DAY), NULL)) AS first_16,
    MIN(IF(days_past_due >= 90, DATE_SUB(effective_delinquency_date, INTERVAL days_past_due - 90 DAY), NULL)) AS first_90
  FROM `epicac-2.epicac_prod_direct.public_delinquent_accounts` WHERE datastream_metadata.change_type != 'DELETE' GROUP BY 1),
stmts AS (
  SELECT user_id, MIN(to_date) first_to_date FROM (
    SELECT id, user_id, to_date, datastream_metadata.change_type ct FROM `epicac-2.epicac_prod_direct.public_statements`
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY datastream_metadata.source_timestamp DESC) = 1) WHERE ct != 'DELETE' GROUP BY 1),
-- FPD proxy at account level: first >15 DPD date within ~35 days after the first statement close (first statement was the one missed)
acct AS (
  SELECT i.user_id, i.cohort_month, h.first_16, h.first_90,
    (h.first_16 IS NOT NULL AND s.first_to_date IS NOT NULL AND h.first_16 <= DATE_ADD(s.first_to_date, INTERVAL 40 DAY)) AS is_fpd
  FROM issuance i LEFT JOIN hist h USING (user_id) LEFT JOIN stmts s USING (user_id)
  WHERE i.cohort_month >= '2025-07-01'),
curve AS (
  SELECT FORMAT_DATE('%Y-%m', cohort_month) cohort, n,
    COUNT(*) users, COUNTIF(NOT is_fpd) users_x, COUNTIF(is_fpd) fpd_users,
    COUNTIF(first_90 <= LAST_DAY(DATE_ADD(cohort_month, INTERVAL n MONTH))) bad90,
    COUNTIF(NOT is_fpd AND first_90 <= LAST_DAY(DATE_ADD(cohort_month, INTERVAL n MONTH))) bad90_x,
    COUNTIF(NOT is_fpd AND first_16 <= LAST_DAY(DATE_ADD(cohort_month, INTERVAL n MONTH))) bad16_x,
    MAX(IF(LAST_DAY(DATE_ADD(cohort_month, INTERVAL n MONTH)) <= DATE_SUB(CURRENT_DATE('Asia/Manila'), INTERVAL 1 DAY), 1, 0)) observable
  FROM acct CROSS JOIN UNNEST([2,3,4,5,6,8,10]) n GROUP BY 1,2)
SELECT cohort, n, observable, users, fpd_users, ROUND(fpd_users/users*100,2) fpd_pct,
  ROUND(SAFE_DIVIDE(bad90,users)*100,2) ever90_pct, ROUND(SAFE_DIVIDE(bad90_x,users_x)*100,2) ever90_xfpd_pct, ROUND(SAFE_DIVIDE(bad16_x,users_x)*100,2) ever16_xfpd_pct
FROM curve ORDER BY 1,2

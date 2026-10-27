# source-reports — warehouse report snapshots cited by analyses in this repo

Copies of date-stamped CSVs produced by the BigQuery report skills (canonical output folder: `~/apps/zed/Analysis+Reports/`, not version-controlled). Each file here is the exact snapshot an analysis cites; regenerate with the command shown and compare stamps — never overwrite a cited snapshot.

| File | Produced by | Cited by |
|---|---|---|
| `vintage_loss_since_origination_month_10262026.csv` | `bash ~/.claude/skills/vintage-loss-report/scripts/run_report.sh` (run 2026-10-26; waterfall 97.0% exact / 1.35% residual PASS; delinquent-book tie 0.17% PASS) | Facility Yield Analysis_20261026.xlsx — loss rates (Inputs rows "Lifetime" / "Since Jan 2026" / "Since Oct 2025") |
| `vintage_loss_by_origination_month_10262026.csv` | same run | Facility Yield Analysis — Sep 2026 originated principal |
| `delinquency_by_issuance_cohort_v2_principal_10262026.csv` | same run | not yet cited; kept with its run |
| `revolver_transactor_balances_2026-01_to_2026-09_10262026.csv` | `bash ~/.claude/skills/revolver-transactor-report/scripts/run_report.sh --from 2026-01 --to 2026-09` (run 2026-10-26; PASS) | Facility Yield Analysis — bucket balances, Sep 2026; verification-notes/2026-10-26-portfolio-yield-vs-losses.md |
| `revolver_transactor_users_2026-01_to_2026-09_10262026.csv` | same run | Zed Unit Economics_vSept.xlsx — revolver share (June 12.98%, Sep 26.88%) |
| `vintage_loss_seasoned_16_30_60_90_by_origination_month_10272026.csv` (+ `.sql`) | ad hoc 2026-10-27: vintage view with the waterfall base inlined and the seasoned denominator computed at 16/30/60/90 days (`due_date <= today − N`), all accounts and ex-FPD | Zed Portfolio Yield Analysis_20261027_DRAFT.xlsx — Loss Rate tab (≥90 DPD, 90-day seasoned: since Jan 2026 1.68% all / 1.15% ex-FPD) |
| `delinquency_by_issuance_cohort_seasoned_16_30_60_90_10272026.csv` (+ `.sql`) | same technique on the issuance-cohort v2 view | not cited in the deliverable (cohort basis covers only 2026-issued users' spend); used in chat 2026-10-27 to show 0.88% ≥90 DPD → 1.88% once seasoned at 90 days |
| `pay_a_friend_transfers_by_month_2026-01_to_2026-09_10272026.csv` | ad hoc 2026-10-27 BigQuery: `public_i2c_web_push_messages`, category FinancialTransaction, Service `C2C Transfer-Others`, response code 00, positive legs only (each transfer posts a ± pair), Manila day of `created_at`, dedup on id by sort_keys[0] | Zed Portfolio Yield Analysis_20261027_DRAFT.xlsx — Monthly Detail "Pay-a-friend transfers" row (Q3 ₱8.35M, 1.9% of Mastercard purchase volume) |

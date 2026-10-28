# July 2026 Fraud Ring: Linked Accounts and Issuance Timeline

Handoff, 2026-10-27. For an agent sizing this ring's effect on 2026 delinquency rates and balances. All money in PHP. Dates are Manila time. Delinquency dates come from `effective_delinquency_date` (the delinquency file is T+1; never use `updated_at`).

## Summary

- **13 user accounts** belong to the ring: 8 issued cards and 5 denied applications. Two clusters: a construction-employer ring of 11 accounts (6 issued, 5 denied) with a March "hub" account, and a Lazada Travel pair (2 issued, Zamboanga).
- **Total limit issued: ₱1,250,000** (hub ₱200,000, seven cards at ₱150,000). **Delinquent balance today: ₱840,794** across 7 accounts, all 30+ DPD, one at 117 DPD. The hub carries a credit balance and is suspended, not delinquent.
- **Issuance timing:** hub 2026-03-18; Robbins 2026-05-06; Foliente 2026-07-13; four construction accounts in one batch run at 06:55 on 2026-07-21 (approved within 40 seconds of each other); Dela Cruz 2026-07-23. Denials on 2026-07-29 (three, Persona needs_review), 2026-07-31 and 2026-08-14 (two, Persona declined).
- **Ops suspended all six construction cards between 2026-07-22 and 2026-08-03.** The Lazada pair was never suspended; both are PastDue only.
- **When they hit the delinquency file (first day >15 DPD):** Robbins 2026-07-18; Foliente 2026-09-18; Aguilar, Lopez, Villar, Deleon and Dela Cruz all on 2026-10-04 (first statements closed 2026-08-31, due 2026-09-18).
- **How they were found:** the first-statement-default analysis (October 2026) linked the July cohort by shared devices, single-household IPv6 prefixes, addresses on Roosevelt Avenue, near-identical construction-manager applications, sequential driver's license numbers, card-to-card transfers into the hub, and Persona's `id_inconsistent_repeat_detection` (same ID image under different names), which also surfaced three May applications denied on 2026-07-29.

## Member accounts

| # | user_id | Name on application | Cluster / role | Signed up | Application outcome | Limit | First stmt close / due | First >15 DPD | DPD today | Delinquent balance today | Standing |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 64eb8bad-7fe9-4d9d-a6b6-fbddf1a5f1e4 | Mark Konstantin Marquez | A, hub (receives transfers) | 2026-03-13 | Issued 2026-03-18 09:41 | 200,000 (raised in June) | 2026-04-30 / 2026-05-18 | never | 0 | 0 (credit balance −33,975) | Suspended 2026-07-29 |
| 2 | 5d67575e-2c74-4aad-85f2-6a5b7b99d327 | Ken Robbins | A, May member | 2026-05-04 | Issued 2026-05-06 11:01 | 150,000 | 2026-06-14 / 2026-07-02 | 2026-07-18 | 117 | 173,265 | PastDue 2026-07-04, Suspended 2026-08-03 |
| 3 | accf9b2d-f2f1-4bd2-aa63-9e504a6da1c1 | Christian Louie Foliente | B, Lazada Travel | 2026-05-31 | Issued 2026-07-13 10:02 | 150,000 | 2026-08-14 / 2026-09-02 | 2026-09-18 | 55 | 161,245 | PastDue 2026-09-04 |
| 4 | 0eef7feb-6940-4b7a-8cd9-f75a89d39748 | James Sy Aguilar | A, July batch | 2026-05-19 | Issued 2026-07-21 06:55 | 150,000 | 2026-08-31 / 2026-09-18 | 2026-10-04 | 39 | 148,736 | Suspended 2026-07-29 |
| 5 | 4ccf6756-24dd-447d-be55-00b355a0579c | Mark Tolentino Lopez | A, July batch | 2026-05-19 | Issued 2026-07-21 06:55 | 150,000 | 2026-08-31 / 2026-09-18 | 2026-10-04 | 39 | 155,473 | Suspended 2026-07-29 |
| 6 | d2ace606-f4d3-4744-a045-5dcbcfbe4edd | Lorenzo Bonza Villar | A, July batch | 2026-05-26 | Issued 2026-07-21 06:55 | 150,000 | 2026-08-31 / 2026-09-18 | 2026-10-04 | 39 | 38,145 | Suspended 2026-07-30 |
| 7 | cd64db52-8aa1-460f-844c-8f3446c69e06 | Myles Sy Deleon | A, July batch (issued with Persona status `declined`) | 2026-05-25 | Issued 2026-07-21 06:55 | 150,000 | 2026-08-31 / 2026-09-18 | 2026-10-04 | 39 | 8,443 (₱139,980 Abenson order returned 2026-08-08) | Suspended 2026-07-22 |
| 8 | da29bb06-a46b-4b4b-a1c6-f68e0bf48b93 | Joey Josell Dela Cruz | B, Lazada Travel | 2026-07-20 | Issued 2026-07-23 13:35 | 150,000 | 2026-08-31 / 2026-09-18 | 2026-10-04 | 39 | 155,486 | PastDue 2026-09-20 |
| 9 | adc2d28b-1edf-4406-bd14-795c28fdd764 | Peter Tan | A, denied (ID image reused) | 2026-05-19 | Denied 2026-07-29 | | | | | | Persona needs_review |
| 10 | 77b4c09a-810f-4bcb-887a-95fde30f1c36 | Mark Aguilar | A, denied (ID image reused) | 2026-05-25 | Denied 2026-07-29 | | | | | | Persona needs_review |
| 11 | 82c513f4-8029-4dcb-9720-81cabca2c5a7 | James Tan | A, denied (ID image reused) | 2026-05-26 | Denied 2026-07-29 | | | | | | Persona needs_review |
| 12 | 56a410ee-e977-4115-87f8-76ea5654070e | Carlos Eleria | A, denied | 2026-07-30 | Denied 2026-07-31 | | | | | | Persona declined |
| 13 | fc91b744-c137-4854-b1ff-ba8d6876d2dd | Henry Castillo | A, denied | 2026-07-30 | Denied 2026-08-14 | | | | | | Persona declined |

Charges and payments on the issued cards (statements closed through 2026-10-20): Robbins ₱149,933 charged, ₱0 paid. Foliente ₱149,930 / ₱0. Aguilar ₱143,685 / ₱0. Lopez ₱149,974 / ₱0. Villar ₱36,063 / ₱0. Deleon ₱147,206 / ₱0 (balance reduced by the return). Dela Cruz ₱149,986 / ₱0. Hub ₱285,229 charged, ₱364,096 paid (payments funded by the transfers below).

## Issuance and delinquency timeline

| Date | Event |
|---|---|
| 2026-03-13 | Hub (Marquez) signs up |
| 2026-03-18 | Hub issued, ₱150,000 |
| 2026-05-04 to 05-06 | Robbins signs up and is issued, ₱150,000 |
| 2026-05-07 | Robbins sends ₱100,000 and ₱10,000 card-to-card to the hub |
| 2026-05-19 to 05-31 | Aguilar, Lopez, Villar, Deleon, Foliente and the three May denials (P. Tan, M. Aguilar, J. Tan) sign up |
| June 2026 | Hub limit raised to ₱200,000 |
| 2026-07-02 | Robbins' first due date; no payment |
| 2026-07-13 | Foliente issued, ₱150,000; spends ₱149,930 at Lazada Travel from the next day |
| 2026-07-18 | Robbins passes 15 DPD (first ring account in the delinquency file) |
| 2026-07-21 06:55 | Aguilar, Lopez, Villar, Deleon issued in one batch run, ₱150,000 each |
| 2026-07-22 | Ops suspends Deleon |
| 2026-07-23 | Dela Cruz issued, ₱150,000; Lopez sends ₱75,000 and ₱50,100 to the hub |
| 2026-07-29 | Ops suspends Aguilar, Lopez and the hub; the three May applications are denied |
| 2026-07-30 | Ops suspends Villar; Eleria and Castillo apply |
| 2026-07-31 | Eleria denied |
| 2026-08-03 | Ops suspends Robbins |
| 2026-08-08 | Deleon's ₱139,980 Abenson order is returned |
| 2026-08-14 | Castillo denied; Foliente's first statement closes |
| 2026-08-31 | First statements close for Aguilar, Lopez, Villar, Deleon, Dela Cruz |
| 2026-09-02 | Foliente's first due date; no payment |
| 2026-09-18 | Foliente passes 15 DPD; first due date for the five August closers; no payments |
| 2026-10-04 | Aguilar, Lopez, Villar, Deleon, Dela Cruz pass 15 DPD |
| 2026-10-27 | Robbins 117 DPD, Foliente 55 DPD, the other five 39 DPD |

## How the accounts link

- **Persona ID-image reuse (`id_inconsistent_repeat_detection`, same ID image under a different name or birthdate).** Aguilar's ID matched the hub, J. Tan and P. Tan; P. Tan matched the hub and M. Aguilar; Robbins matched M. Aguilar and P. Tan; M. Aguilar matched J. Tan; Deleon matched Eleria; Villar matched Castillo. These failed at KYC time; Deleon was issued anyway with Persona status `declined`.
- **Shared devices (public_device_events.device_id).** Aguilar and Villar; Villar and Castillo; Deleon and Eleria.
- **Single-household IPv6 prefixes (Globe 2001:4451:1388:ed00::/64).** Aguilar, Lopez, Villar, Robbins and the hub. A second prefix (2001:4451:1399:7e00::/64): hub, Deleon, Villar. PLDT 2001:fd8:17c6:bc2a::/64: Aguilar and Villar. IPv4 112.205.223.12: hub and Deleon; 112.205.81.222: Deleon and Eleria. Persona session IP 161.49.192.210: Aguilar and P. Tan.
- **Addresses.** Deleon and Villar at 132 and 138 Roosevelt Avenue, Del Monte, Quezon City; Eleria and Castillo also gave Roosevelt Avenue.
- **Applications.** All construction operations managers or supervisors (DATEM, EEI, Babel Aggregates, Budo Aggregates, Megaworld Construction, DMCI, SMDC), stated incomes ₱165,000 to ₱250,000, mother's maiden name "Sy" or "Maria Sy" on three. Driver's license numbers for Lopez, Aguilar and Robbins are N0216179039, N0216182781 and N0216188261, one issuance series.
- **Money flow.** Card-to-card transfers from new accounts into the hub (Robbins ₱110,000 in May, Lopez ₱125,100 in July) appear as the hub's statement payments; the hub got a limit raise and ended with a credit balance.
- **Invites.** Every member redeemed an invite code created under a different first name or email from the application (e.g. Aguilar's code DNVVY9U was for "John", playpark1002@gmail.com; Villar's R0WUREX was for "Henry", the name later used by Castillo; Foliente's 4942B0E was for "Hector", Bioco.eden@gmail.com; Dela Cruz's WNRLF4F for "Jonathan Manansala").
- **Lazada pair.** Foliente (Zamboanga) and Dela Cruz (Parañaque) each spent the whole limit at Lazada Travel starting the day after issuance, in repeating amounts of ₱5,400 and ₱10,810; Dela Cruz's physical card was used in Zamboanga. No device or IP overlap with cluster A; linked to each other by behaviour and geography only.

## Exposure and delinquency for sizing

Ring delinquent balance at month end (accounts in the delinquency file; balance from the latest file row on or before the date):

| As of | Ring accounts in file | 15+ DPD | 30+ DPD | 90+ DPD | Delinquent balance, 15+ DPD | Delinquent balance, all in file |
|---|---|---|---|---|---|---|
| 2026-07-31 | 1 | 1 | 0 | 0 | 155,431 | 155,431 |
| 2026-08-31 | 1 | 1 | 1 | 0 | 161,249 | 161,249 |
| 2026-09-30 | 7 | 2 | 1 | 0 | 322,825 | 809,508 |
| 2026-10-26 | 7 | 7 | 7 | 1 | 840,794 | 840,794 |

By statement month (anchored on `to_date`): the ring contributes one first-statement default in the June 2026 statement month (Robbins, closed 2026-06-14), one in August (Foliente, closed 2026-08-14), and five in August (closed 2026-08-31). For a cohort view by issuance month: March 1 (hub, not delinquent), May 1, July 6.

Expected trajectory: all seven delinquent accounts have paid nothing; absent recoveries they roll to 90+ DPD on 2026-10-01 (Robbins, already there), 2026-12-02 (Foliente) and 2026-12-18 (the five), and to 180 DPD in early 2027. Deleon's balance is small only because of the merchandise return.

## How to reproduce

```sql
-- member ids
WITH ring AS (SELECT user_id FROM UNNEST([
'0eef7feb-6940-4b7a-8cd9-f75a89d39748','4ccf6756-24dd-447d-be55-00b355a0579c','cd64db52-8aa1-460f-844c-8f3446c69e06',
'd2ace606-f4d3-4744-a045-5dcbcfbe4edd','accf9b2d-f2f1-4bd2-aa63-9e504a6da1c1','da29bb06-a46b-4b4b-a1c6-f68e0bf48b93',
'5d67575e-2c74-4aad-85f2-6a5b7b99d327','64eb8bad-7fe9-4d9d-a6b6-fbddf1a5f1e4','56a410ee-e977-4115-87f8-76ea5654070e',
'fc91b744-c137-4854-b1ff-ba8d6876d2dd','adc2d28b-1edf-4406-bd14-795c28fdd764','77b4c09a-810f-4bcb-887a-95fde30f1c36',
'82c513f4-8029-4dcb-9720-81cabca2c5a7']) user_id)
-- issued set = the first 8; denied set = the last 5
SELECT * FROM ring;
```

Tables (all in `epicac-2.epicac_prod_direct`, CDC append-only; dedupe with `QUALIFY ROW_NUMBER() OVER (PARTITION BY <pk> ORDER BY datastream_metadata.source_timestamp DESC) = 1`):

- `public_account_status_transitions` (pk id; status history, `date`), `public_account_standing_changelog` (pk id; suspensions, `updated_at`), `public_cards` (pk id; `credit_limit` STRING), `public_statements` (pk id; month = `to_date`; charges = `total_charges_net_installments`), `public_delinquent_accounts` (pk user_id for current; full history by `effective_delinquency_date`; `days_past_due`, `delinquent_balance` STRING), `public_user_personals` (pk user_id; `onboarding_data` and `persona` JSON), `public_device_events`, `public_access_codes`, `public_pdf_bank_statements`.
- First day >15 DPD for an account = `MIN(effective_delinquency_date - (days_past_due - 16))` over its history rows with `days_past_due > 15`.
- Month-end ring delinquent balance: for each month end take each member's latest delinquency row with `effective_delinquency_date <= month_end`, sum `delinquent_balance` where `days_past_due > 15`.

Caveats: the delinquency file lags by a day; `public_transfer_sessions` does not hold the card-to-card transfers cited above (they came from i2c push messages, transaction type C2C, in the October investigation); the hub's limit raise date is "June 2026" from the credit limit changelog, exact day not re-pulled here. The seven delinquent balances include interest and fees accrued since the first statement, so they exceed the ₱150,000 limits.

## Fraud controls: rollout dates and one-line descriptions

Source: the daily `app_review_scores` decision sheet. Tabs through 2026-10-23 carry only the credit knockouts (Low ADB, model score). The 2026-10-24 decisioning run (BigQuery `zed_data_science.app_review_sheet_20261024`) is the first with the fraud rules; the 2026-10-26 tab is the first ops-facing day with them.

| Control | Rollout | One line |
|---|---|---|
| Manual ring takedown | 2026-07-22 to 2026-08-03 | Ops suspended the six issued construction-ring cards and denied the five linked applications after the July cohort was traced by device, IP, address and Persona ID-image matches. |
| Duplicate-applicant block (name + DOB, ID number, email, cardholder) | In place by 2026-10-01 | Applicants matching an existing account on exact full name and DOB or on Persona ID number are routed to review as `duplicate user`. |
| Shared bank account number knockout | 2026-10-24 | Any applicant whose uploaded statement carries an account number already seen on another applicant's statement is auto-declined (`KO:Shared bank acct`). |
| Persona repeat-match screen | 2026-10-24 | Failed selfie or ID-image repeat checks resolve to the matched account and decline or hold; an unscreened selfie (`image_quality_low`) holds for re-KYC. |
| Invite first-name mismatch knockout | 2026-10-24 | An invite redeemed under a first name that does not match the application (after nickname, middle-name and email checks) is auto-declined (`KO:Invite name mismatch`). |
| Business-owner income haircut and EDD | 2026-10-24 | Self-declared business owners get limits on 50% of declared income and are routed to document review (`EDD: biz registration, ITR`). |
| CIBI past-due knockout | 2026-10-24 | Applicants with a past-due tradeline on the CIBI credit report are auto-declined (`KO:CIBI past due`); a credit rule, not a fraud rule, but it is the largest new screen (172 of 993 in the first run). |

Suggested controls sentence: "Fraud controls were tightened in two steps: the July ring was suspended manually between 22 July and 3 August 2026, and from the 24 October 2026 decisioning run every application is screened for shared bank account numbers, Persona selfie and ID-image repeats, invite-name mismatches and CIBI past-due tradelines, with business-owner limits set on half of declared income pending documents."

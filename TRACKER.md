# Diligence Tracker

**Status:** v1 — imported from `Diligence Responses_20260805 (1).xlsx` (sent to the fund 2026-08-05). 3 open (4.2, 5.1, and 5.2 — likely already fulfilled, see note), 1 partial (2.2), 10 closed.
**This file is the source of truth.** The outbound spreadsheet is generated from it via `scripts/export_responses.py`. Lines marked `**Note (internal):**` are never exported.

**Changelog**
- **v1 (2026-09-01):** Imported all 14 items verbatim from the 8/5 response spreadsheet. Flagged that `Installment Tape_20260814.xlsx` (now in Data Room / Loan Tape) appears to fulfill 5.2 and the detail promised in 2.2 — statuses left as sent, pending Steve's confirmation.

**Item statuses:** `Open` (we owe an answer) · `Drafted` (response written, not yet reviewed/sent) · `Partial` (sent, more owed) · `Closed` (sent and complete).

---

## 1. Revolving credit — launch and economics

### 1.1 Launch date [Closed]
**Q:** Launch date for revolving credit?
**A:** May 25th; first statement end dates with minimum balances due were June 1 and June 15.
**Delivered:** response sheet 2026-08-05

### 1.2 APR, minimum payment and eligibility [Closed]
**Q:** Target APR, minimum payment formula, and eligibility criteria at launch. Does the full book qualify on day one, or selected cohorts/score bands only?
**A:** APR for all customers is 3% monthly.

All accounts were eligible at launch, but past-due balances were still considered past-due. Only charges after revolving launched were able to revolve.

Minimum payment due (in pesos) = max(10%\*(statement ending balance - late fees - past due amount - installment billings) + late fees + past due balance + installment billings, 1000)
**Delivered:** response sheet 2026-08-05

### 1.3 Adoption / balance mix [Closed]
**Q:** Expected share of balances revolving at month 6 and month 12 post-launch?
**A:** ~23% of the base is revolving as of July. We expect the share of revolvers will rise over the next year and we are tracking it closely
**Delivered:** response sheet 2026-08-05

### 1.4 Provisioning and delinquency treatment [Closed]
**Q:** Provisioning approach for revolving balances, and how the credit policy treats a revolver that subsequently goes delinquent (limit freeze, re-age rules, minimum-payment escalation).
**A:** Zed applies a single Net Flow Rate provisioning methodology across all balances with segmentation driven by days past due rather than product type (there is only one product type), so revolving balances flow through the same eight DPD buckets (Current through 181+) as installment loans. Once a revolver becomes past due, we apply a hard card freeze at DPD 1. Zed reserves the right to collect the entire balance in such an event. Re-aging to Current requires all arrears cleared.
**Delivered:** response sheet 2026-08-05

## 2. Asset economics — pre- and post-revolving

### 2.1 Installment fee economics and cancellations [Closed]
**Q:** Installments are 18.2% of the June 30 book at a ~7.2% blended fee on volume, with ~11% of originated volume cancelled. Term distribution behind the blended fee, and fee treatment on cancellation (refunded or retained)?
**A:** See attached for a revised statement tape including installment conversions. The blended installment charges are ~3.2%, and cancellations are ~5.1% of originated volume. Cancellations contain past due-related accelerations (6 DPD) and customer initiated "end plan early" availments. The ~3.2% installment charges includes upfront fees and current month interest (cancellation fee).

If an installment is 'cancelled' in the first month, the initial upfront fee is reversed and there is no cancellation fee. Otherwise, the cancellation fee is equal to that month's interest, and the upfront fee remains.

Upfront fees are 1.5% (3 mo), 3% (6 mo), and 6% (12 mo)
**Delivered:** response sheet 2026-08-05, with `Statement Tape_20260630_vF.xlsx` attached via email
**Note (internal):** The revised statement tape (vF, with Installment Conversions column) was later superseded in the data room — Payment Data now holds `Statement Tape_20260630.xlsx` and `Statement Tape_20260731.xlsx` (the 7/31 tape adds Interest and Installment Conversions columns).

### 2.2 Plan mechanics and performance [Partial]
**Q:** The June 30 tape shows every account with a live installment balance as Current — we assume plans are cancelled or accelerated into the statement balance on delinquency. Confirm the mechanics, and provide delinquency and loss performance on a plan-level basis.
**A:** Correct on the mechanics - additional detail on installment loans to be provided.

Installment loans and associated terms do not exist indepedently of the credit card balance. Installments are billed on the credit card statement cycles. Once billed, they are technically added to the purchase/revolving balance. Because of our min payment rules, we expect full payment of the installment billing by the due date in order to keep the account in good standing. But it is technically not possible to delinquent on an installment plan independent of the credit card, because they're all part of the same expected minimum payment and credit card product.
**Delivered:** response sheet 2026-08-05
**Note (internal):** The promised "additional detail" is likely `Installment Tape_20260814.xlsx` (Data Room / Loan Tape). If the fund has been told it's there, this can move to Closed — confirm with Steve.

### 2.3 Unit economics [Closed]
**Q:** Unit economics per active account today (interchange, installment fees, late fees, less credit cost and processing cost), and the same view pro forma with revolving at your base-case adoption.
**A:** See attached for current and PF unit economics.
**Delivered:** response sheet 2026-08-05, with `Zed Unit Economics_vF.xlsx` attached via email (non-standard request → email, not data room)

## 3. Underwriting and credit risk

### 3.1 Cohort delinquency drivers and target losses [Closed]
**Q:** 2024Q3–2025Q2 cohorts show 10–25% of accounts ever reaching 90+ DPD — high for a prime positioning. What drove this, what changed, and what is the target loss rate for 2026 vintages at the re-leveled limits?
**A:** Earlier cohorts (Q3 2024's N=100) are too small to infer anything meaningful (these were our very first issuances beyond friends and family). Q2 2025 (N=1,087) is a larger cohort with 9.8% currently 90+ DPD but still small as we begin adding thousands of cardholders per quarter going forward. Improvements in past due rates are a result of model refinements in Q3 and Q4 2025 as we began incorporating actual performance to better inform probability of default.
**Delivered:** response sheet 2026-08-05

### 3.2 Limit re-leveling guardrails [Closed]
**Q:** Credit limit re-leveling raised the median limit from PHP 35K to PHP 50K in March 2026. What guardrails cap exposure growth for accounts with limited payment history, and how will limits interact with revolving eligibility?
**A:** We don't increase credit limits for accounts that have ever had a serious past due balances (15+ DPD per our current policy). We set small initial limits that increase as cardholders display positive payment history. The initial line is set at min(ADB, 2x income) today; it was 1x income until March 23, 2026. We did a portfolio wide reevaluation of CLs in preparation for installment and revolving launch and are comfortable with our current policy.
**Delivered:** response sheet 2026-08-05

## 4. Charge-off, collections, and recoveries

### 4.1 Charge-off policy [Closed]
**Q:** The June 30 tape carries PHP 11.1M of 180+ DPD with no write-off. What is the charge-off policy (we would expect write-off at 180 DPD), and when will a written policy be adopted?
**A:** In line with our ECL policy, we have set-up 100% provisioning for accounts that are 180+ DPD. We have not officially written anything off due to resource constraints. As an early-stage company with a lean PH team, we have not yet stood up the collections-substantiation and BIR documentation process required to write off (the tax code worthlessness tests require documented, exhausted collection efforts per account). We are building this process out.
**Delivered:** response sheet 2026-08-05

### 4.2 Recoveries [Open]
**Q:** Recoveries achieved on 90+ DPD balances to date?
**A:** To be provided.
**Note (internal):** Candidate for a BigQuery pull (payments received on accounts that were 90+ DPD at time of payment) via the prod-data-warehouse skill.

## 5. Data requested

### 5.1 Payment-level tape [Open]
**Q:** Per transaction/payment: full payment-level tape (charge date, payment date, amount) for all accounts since inception — transactions and payments, not statement summaries.
**A:** To discuss.
**Note (internal):** Positioned as "to discuss" in the 8/5 response — decision owed by Steve on whether to provide raw transaction/payment-level data.

### 5.2 Installment plan tape [Open]
**Q:** Per installment plan: plan ID, origination date, term, fee, status, cancellation/acceleration date and reason.
**A:** To be provided.
**Note (internal):** `Installment Tape_20260814.xlsx` (Data Room / Loan Tape) matches this request field-for-field (plan ID, origination/opt-in date, tenure, fees, status, termination date/source). If the fund has access, mark Closed with a pointer response — confirm with Steve.

### 5.3 Cohort performance file [Closed]
**Q:** Per cohort: monthly origination, outstanding, and cumulative gross/net loss by MOB, split purchase vs. installment.
**A:** The loan tape shows unique cardholders and their origination cohort, which can be joined with the statement tape to show, by unique cardholder, statement charges and credits. We added gross installment conversions as well. DPD columns show what statements balances ever went past due or are currently past due. The statement data can be used to reconstruct every unique cardholders charges and payment history by using the UID key.
**Delivered:** response sheet 2026-08-05

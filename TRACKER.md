# Diligence Tracker

**Status:** v2 — processed FPF follow-up email (Raymond Katz, 2026-08-26). 8 open (2.4, 2.5, 2.7, 4.3, 5.1, 5.4, 5.5, 6.1), 1 drafted awaiting Steve review (2.6), 13 closed.
**This file is the source of truth.** The outbound spreadsheet is generated from it via `scripts/export_responses.py`. Lines marked `**Note (internal):**` are never exported.

**Changelog**
- **v2 (2026-09-01):** Processed the FPF email thread (inbox). Closed 4.2 (90+ recovery breakdown emailed 2026-08-11), 5.2 and 2.2 (installment plan tape emailed 2026-08-21 — Steve's email: "close out the last open item (5.2)"). Added the 8 new questions from Katz's 8/26 email as 2.4–2.7, 4.3, 5.4, 5.5, and new section 6 (Pricing and regulatory). Verified the fee schedule against `Installment Tape_20260814.xlsx` (all 4,974 plans: upfront = 0.5% × term months; add-on = 1.0%/month on 4,897 plans, 77 at 0%) — drafted 2.6 on that basis. 5.1 stays open pending the outcome of the 8/12 call.
- **v1 (2026-09-01):** Imported all 14 items verbatim from the 8/5 response spreadsheet. Flagged that `Installment Tape_20260814.xlsx` (now in Data Room / Loan Tape) appears to fulfill 5.2 and the detail promised in 2.2 — statuses left as sent, pending Steve's confirmation.

**Item statuses:** `Open` (we owe an answer) · `Drafted` (response written, not yet reviewed) · `Approved` (Steve signed off in the working sheet; exports as Closed) · `Partial` (sent, more owed) · `Closed` (sent and complete).

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

### 2.2 Plan mechanics and performance [Closed]
**Q:** The June 30 tape shows every account with a live installment balance as Current — we assume plans are cancelled or accelerated into the statement balance on delinquency. Confirm the mechanics, and provide delinquency and loss performance on a plan-level basis.
**A:** Correct on the mechanics - additional detail on installment loans to be provided.

Installment loans and associated terms do not exist indepedently of the credit card balance. Installments are billed on the credit card statement cycles. Once billed, they are technically added to the purchase/revolving balance. Because of our min payment rules, we expect full payment of the installment billing by the due date in order to keep the account in good standing. But it is technically not possible to delinquent on an installment plan independent of the credit card, because they're all part of the same expected minimum payment and credit card product.
**Delivered:** response sheet 2026-08-05; the promised plan-level detail delivered as the installment tape, email 2026-08-21 (see 5.2)

### 2.3 Unit economics [Closed]
**Q:** Unit economics per active account today (interchange, installment fees, late fees, less credit cost and processing cost), and the same view pro forma with revolving at your base-case adoption.
**A:** See attached for current and PF unit economics.
**Delivered:** response sheet 2026-08-05, with `Zed Unit Economics_vF.xlsx` attached via email (non-standard request → email, not data room)

### 2.4 Installment purchase — economics walkthrough [Open]
**Q:** Walk through the economics of a typical installment purchase, from the swipe through to final payment: revenue lines and their timing (interchange net of network and processor costs, what's charged upfront at origination, what accrues over the term), plus the flow of funds — who pays whom, when, and which entity each flow lands in.
**A:** [draft skeleton — revenue lines and timing:] At the swipe, Zed earns interchange on the purchase, net of network and processor costs [Steve: net interchange economics — see 2.7]. At plan opt-in, an upfront fee of 0.5% × term months (1.5% / 3% / 6% for 3/6/12-month terms) is charged to the account. Over the term, add-on interest of 1% of original principal per month is billed on each monthly statement. On early termination, a cancellation fee equal to the current month's interest applies and the upfront fee is retained (both reversed/waived if cancelled in the first month). [Steve: flow of funds — who pays whom, when, and which entity each flow lands in.]
**Note (internal):** Fund email 2026-08-26, item 1. Fee mechanics verified against the installment tape (see METHODS.md). The entity/flow-of-funds half cannot be drafted from repo materials — Steve/finance owe it.

### 2.5 Revolver and pay-in-full — economics walkthrough [Open]
**Q:** Same walkthrough for a revolving balance and for a pay-in-full statement, to see how the three products differ economically.
**A:** [draft skeleton:] Pay-in-full: Zed earns interchange on spend; no interest or fees if paid by the due date. Revolver: interchange on spend plus interest at 3% per month on the revolving balance; minimum payment per the formula in 1.2. Late fees apply to either on missed payment. [Steve: flow of funds and entity detail, consistent with 2.4.]
**Note (internal):** Fund email 2026-08-26, item 2. Rates grounded in 1.2 (sent). Same flow-of-funds gap as 2.4.

### 2.6 Fee schedule confirmation [Drafted]
**Q:** Confirm the fee schedule: add-on rate by tenor, and the origination fee formula (told 0.5% × number of months; 3% on a 6-month term). Is the fee netted from the disbursement or financed into the balance? Refundable on prepayment? Is unearned add-on interest rebated?
**A:** Confirmed. The origination fee is 0.5% × term months (1.5% for 3-month, 3% for 6-month, 6% for 12-month terms) and the add-on rate is 1% of original principal per month, flat across tenors. There is no cash disbursement — an installment plan converts an existing card purchase — so nothing is netted: the origination fee is charged to the account and billed on the statement. If a plan is terminated in the first month, the origination fee is reversed and no cancellation fee applies; after the first month, the origination fee is retained and a cancellation fee equal to the current month's interest is charged. Add-on interest is billed monthly only while the plan is active, so unearned interest for remaining months is never charged (no rebate needed).
**Note (internal):** Fund email 2026-08-26, item 4. Verified against all 4,974 plans in `Installment Tape_20260814.xlsx` (see METHODS.md): upfront/principal exactly 0.5% × months; monthly interest/principal exactly 1.0% on 4,897 plans; 77 plans show 0% interest — [Steve: promo plans? worth knowing before the fund asks]. Consistent with the 2.1 response already sent.

### 2.7 Net interchange as % of GMV [Open]
**Q:** Net interchange as a percentage of GMV for the last six months, split domestic vs international if possible.
**A:** To be provided.
**Note (internal):** Fund email 2026-08-26, item 6. Candidate BigQuery pull — needs Steve's sign-off on definitions before running (net of network + processor costs? which GMV base? is the domestic/international split available in our data?). Unit econ file shows interchange only bundled with installment interest and fees ($6.41/account/mo), so this is a new cut.

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

### 4.2 Recoveries [Closed]
**Q:** Recoveries achieved on 90+ DPD balances to date?
**A:** Provided — see the "90+ Recovery Summary" tab added to the statement tape, with trace-back columns on the original tape so the derivation is auditable.
**Delivered:** email 2026-08-11 (Katz acknowledged receipt same day)
**Note (internal):** We do not have a copy of the file that was sent (statement tape + "90+ Recovery Summary" tab) — Steve to drop it into `Prior Responses (outside data room)/` so the repo matches what the fund holds.

### 4.3 Loss figure basis, charge-off policy, restructures [Open]
**Q:** What's the basis for the ~2% loss figure provided (30+/90+ DPD, annualized NCL, cumulative) and its denominator? Charge-off policy in DPD, any change since launch, and approach to restructures/re-aging.
**A:** [policy half, from 4.1/1.4 as sent:] Per our ECL policy we provision 100% at 180+ DPD; we have not yet formally written off balances while we stand up the collections-substantiation and BIR documentation required, and the policy is unchanged since launch. Re-aging to Current requires all arrears cleared. [Steve: basis and denominator of the ~2% figure; whether any restructure program exists.]
**Note (internal):** Fund email 2026-08-26, item 8. **The ~2% loss figure appears in no repo artifact** — the shared unit econ file implies loan-loss provision ≈ 49% of gross revenue per active account, so ~2% must be a different basis (likely quoted on the 8/12 call or in the deck). Steve must identify where it came from and its intended definition before we answer; getting this wrong contradicts something the fund already heard.

## 5. Data requested

### 5.1 Payment-level tape [Open]
**Q:** Per transaction/payment: full payment-level tape (charge date, payment date, amount) for all accounts since inception — transactions and payments, not statement summaries.
**A:** To discuss.
**Note (internal):** Positioned as "to discuss" in the 8/5 response — decision owed by Steve on whether to provide raw transaction/payment-level data. A call to scope this was held 2026-08-12 3:30pm Panama time (per email thread); outcome not recorded anywhere in the repo — Steve to say what was agreed so this can move.

### 5.2 Installment plan tape [Closed]
**Q:** Per installment plan: plan ID, origination date, term, fee, status, cancellation/acceleration date and reason.
**A:** Provided — plan-level installment tape (plan ID, opt-in date, tenure, upfront fee, monthly interest, status by month, termination date/source), also in Data Room / Loan Tape.
**Delivered:** email 2026-08-21 ("close out the last open item on our side (5.2)"); `Installment Tape_20260814.xlsx` in Data Room / Loan Tape
**Note (internal):** Confirm the emailed attachment is byte-identical to the data-room copy; if it differs, archive the emailed version in `Prior Responses (outside data room)/`.

### 5.3 Cohort performance file [Closed]
**Q:** Per cohort: monthly origination, outstanding, and cumulative gross/net loss by MOB, split purchase vs. installment.
**A:** The loan tape shows unique cardholders and their origination cohort, which can be joined with the statement tape to show, by unique cardholder, statement charges and credits. We added gross installment conversions as well. DPD columns show what statements balances ever went past due or are currently past due. The statement data can be used to reconstruct every unique cardholders charges and payment history by using the UID key.
**Delivered:** response sheet 2026-08-05

### 5.4 "Installment fees" field definition [Open]
**Q:** Define what the "installment fees" field in the tape contains: the upfront origination fee, the monthly add-on interest, or both combined.
**A:** To be provided.
**Note (internal):** Fund email 2026-08-26, item 3. Do not draft from inference — the answer depends on how the tape extract was built. Verify empirically (trace plans from the installment tape into their statement-tape rows, and/or against the warehouse) or confirm with whoever built the extract (Josif?), then write the definition. Verification was in progress when this turn paused.

### 5.5 Revenue fields absent from the tape [Open]
**Q:** The tape shows late fees and installment fees but no interchange, annual fee, upfront fee, cash advance fee, etc. Is that because those revenues do not attach to the receivable, or because they were excluded from the extract?
**A:** [partial draft:] Interchange is earned on the merchant/network side of each transaction and never posts to the cardholder account, so it does not appear in a receivables tape. [Steve: confirm which of the other fee types exist at all as Zed products (annual fee? cash advance?) — the honest answer may simply be that these products don't exist — and whether anything that does bill to cardholders was excluded from the extract.]
**Note (internal):** Fund email 2026-08-26, item 5. Ties to 5.4 — answer both together once the extract's contents are confirmed.

## 6. Pricing and regulatory

### 6.1 BSP rate ceilings and pricing headroom [Open]
**Q:** Both the revolving rate (3%/month) and installment add-on (1%/month) sit exactly at the BSP ceilings. Confirm there is no pricing headroom, and what happens to program economics if BSP cuts the ceiling at a semiannual review.
**A:** [partial draft:] Confirmed — our revolving rate is 3% per month and the installment add-on is 1% per month, at the current BSP ceilings. [Steve: the sensitivity answer — impact on program economics of a ceiling cut, and any mitigants (fee mix, funding cost, underwriting).]
**Note (internal):** Fund email 2026-08-26, item 7. Rates verified (1.2 as sent; installment tape per METHODS.md). The headroom/sensitivity narrative is strategy — Steve's voice required. Consider whether the unit econ pro forma should be the quantitative backbone of the answer.

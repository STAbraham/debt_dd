# Diligence Tracker

**Status:** v6 — all 14 initial-doc items closed. Live work is the 8/26 email batch: 5 open (items 3, 5, 6, 7, 8), 3 drafted awaiting Steve review (items 1, 2, 4).
**This file is the source of truth.** The outbound spreadsheet is generated from it via `scripts/export_responses.py`; Steve reviews in `WORKING - Diligence Responses.xlsx`. Lines marked `**Note (internal):**` are never exported.
**ID convention:** IDs are exactly the fund's own numbering for each request batch. The initial questions doc was unnumbered bullets under sections, so it became 1.1–5.3 (section.order); the 2026-08-26 email numbers its questions 1–8, so those items are simply 1–8. When citing an item, name the batch if ambiguous ("8/26 item 3"). IDs never change once a response sheet containing them has been sent.

**Changelog**
- **v6 (2026-09-01):** Working-sheet sync. Steve supplied the full installment economics walkthrough for item 1 (upfront fee billed entirely in enrollment cycle; 1%/mo add-on totalling 3/6/12% by term end; first-cycle cancellation treated as a graceful foot-fault unwind) — restructured per his note and used as the template for item 2's revolver/pay-in-full walkthrough (grounded in 1.2/1.4 as sent). Both now Drafted; flow-of-funds/entity half remains an explicit placeholder in each.
- **v5 (2026-09-01):** Processed Granola notes from the 8/12 call (inbox → processed). 5.1's resolution recorded: Raymond clarified he does not need transaction-level data — the statement tape's per-user statement/payment history covers the intent. The "~2% loss figure" in 8/26 item 8 is now grounded: it's the call's headline metric, dollars originated that go past due (target 1–3%, currently ~2%, vs US prime benchmarks) — item 8 draft upgraded, exact computation still to verify. Context notes added to items 2 and 7. Raymond owes Zed indicative terms per the call.
- **v4 (2026-09-01):** Closed 5.1 per Steve (resolved after the 8/12 call). Renumbered the 8/26 batch from 6.1–6.8 to the email's own numbering, 1–8, per Steve — the tracker mirrors each batch's numbering verbatim.
- **v3 (2026-09-01):** Renumbered the 8/26 follow-up questions into section 6 (6.1–6.8, matching the email's own order) after Steve supplied the fund's original questions doc, confirming the convention that IDs track the fund's list order. Old IDs 2.4→6.1, 2.5→6.2, 5.4→6.3, 2.6→6.4, 5.5→6.5, 2.7→6.6, old 6.1→6.7, 4.3→6.8 — safe because none were ever sent. Original questions doc archived to inbox/processed.
- **v2 (2026-09-01):** Processed the FPF email thread (inbox). Closed 4.2 (90+ recovery breakdown emailed 2026-08-11), 5.2 and 2.2 (installment plan tape emailed 2026-08-21 — Steve's email: "close out the last open item (5.2)"). Added the 8 new questions from Katz's 8/26 email. Verified the fee schedule against `Installment Tape_20260814.xlsx` (all 4,974 plans: upfront = 0.5% × term months; add-on = 1.0%/month on 4,897 plans, 77 at 0%) — drafted the fee-schedule response on that basis. 5.1 stays open pending the outcome of the 8/12 call.
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

## 5. Data requested

### 5.1 Payment-level tape [Closed]
**Q:** Per transaction/payment: full payment-level tape (charge date, payment date, amount) for all accounts since inception — transactions and payments, not statement summaries.
**A:** To discuss.
**Delivered:** "To discuss" sent in the 8/5 response sheet; resolved on the 2026-08-12 call
**Note (internal):** Per the 8/12 call notes (inbox/processed/2026-08-12-fpf-5.1-call-granola-notes.md): Raymond clarified he does **not** want a transaction-level dump (~2.2M rows) — the goal is tracing each cardholder's statement and payment history, which the statement tape already provides. Josif walked him through the tapes on the call. No further deliverable owed.

### 5.2 Installment plan tape [Closed]
**Q:** Per installment plan: plan ID, origination date, term, fee, status, cancellation/acceleration date and reason.
**A:** Provided — plan-level installment tape (plan ID, opt-in date, tenure, upfront fee, monthly interest, status by month, termination date/source), also in Data Room / Loan Tape.
**Delivered:** email 2026-08-21 ("close out the last open item on our side (5.2)"); `Installment Tape_20260814.xlsx` in Data Room / Loan Tape
**Note (internal):** Confirm the emailed attachment is byte-identical to the data-room copy; if it differs, archive the emailed version in `Prior Responses (outside data room)/`.

### 5.3 Cohort performance file [Closed]
**Q:** Per cohort: monthly origination, outstanding, and cumulative gross/net loss by MOB, split purchase vs. installment.
**A:** The loan tape shows unique cardholders and their origination cohort, which can be joined with the statement tape to show, by unique cardholder, statement charges and credits. We added gross installment conversions as well. DPD columns show what statements balances ever went past due or are currently past due. The statement data can be used to reconstruct every unique cardholders charges and payment history by using the UID key.
**Delivered:** response sheet 2026-08-05

## 6. Follow-up questions (fund email 2026-08-26 — items keep the email's own numbers 1–8)

### 1 Installment purchase — economics walkthrough [Drafted]
**Q:** Walk through the economics of a typical installment purchase, from the swipe through to final payment: revenue lines and their timing (interchange net of network and processor costs, what's charged upfront at origination, what accrues over the term), plus the flow of funds — who pays whom, when, and which entity each flow lands in.
**A:** Interchange: at the swipe, Zed earns interchange on an installment-enrolled purchase exactly as on any other transaction (net interchange economics covered in item 6).

Origination: at enrollment, an upfront fee of 0.5% × term months (1.5% / 3% / 6% for the 3 / 6 / 12-month terms, respectively) is charged to the account and billed in its entirety in the statement cycle in which the purchase was enrolled.

Over the term: add-on interest of 1% × original principal is billed on each monthly statement — so by end of term, total interest of 3% / 6% / 12% of principal has been charged for the 3 / 6 / 12-month terms.

Early termination: a cancellation fee equal to the current statement cycle's interest is charged and the upfront fee is retained, with one exception — if a purchase is enrolled into installments and cancelled within that same first statement cycle, we charge no interest and reverse the upfront fee. Nothing has been billed at that point and the user hasn't yet floated any of the purchase via installments, so we treat it as a foot fault and allow them to unwind the enrollment without any implications.

[Steve: the question also asks for the flow of funds — who pays whom, when, and which entity each flow lands in. Answer here, or handle on the follow-up call?]
**Note (internal):** Fund email 2026-08-26, item 1. Steve's own explanation (working-sheet sync 2026-09-01), lightly restructured per his note; fee mechanics verified against the installment tape (see METHODS.md). Flow-of-funds/entity half still unanswered — kept as an explicit placeholder.

### 2 Revolver and pay-in-full — economics walkthrough [Drafted]
**Q:** Same walkthrough for a revolving balance and for a pay-in-full statement, to see how the three products differ economically.
**A:** Interchange: identical to the installment case — at the swipe, Zed earns interchange on the purchase like any other transaction, regardless of how the balance is later paid.

Pay-in-full: charges aggregate into the statement balance at cycle end. If the cardholder pays the statement balance in full by the due date, no interest or fees are ever charged — the economics to Zed are interchange only.

Revolving: if the cardholder pays at least the minimum payment (formula per our response to 1.2) but less than the full statement balance, the unpaid remainder revolves and accrues interest at 3% per month. Only charges made after the revolving launch are eligible to revolve.

Missed payment: if the minimum payment is not met by the due date, late fees are charged, the account becomes past due, and a hard card freeze applies at DPD 1 (per our response to 1.4).

[Steve: flow of funds and entity detail, same as item 1.]
**Note (internal):** Fund email 2026-08-26, item 2. Rates grounded in 1.2 (sent). Same flow-of-funds gap as item 1. Context the fund heard on the 8/12 call: revolving is the primary revenue driver; 33% of users use installments or revolving, 7% both, 10% installments only; installment users skew transactor. Verify these figures before putting them in a written response.

### 3 "Installment fees" field definition [Open]
**Q:** Define what the "installment fees" field in the tape contains: the upfront origination fee, the monthly add-on interest, or both combined.
**A:** To be provided.
**Note (internal):** Fund email 2026-08-26, item 3. Do not draft from inference — the answer depends on how the tape extract was built. Verify empirically (trace plans from the installment tape into their statement-tape rows, and/or against the warehouse) or confirm with whoever built the extract (Josif?), then write the definition. Verification pending — see METHODS.md.

### 4 Fee schedule confirmation [Drafted]
**Q:** Confirm the fee schedule: add-on rate by tenor, and the origination fee formula (told 0.5% × number of months; 3% on a 6-month term). Is the fee netted from the disbursement or financed into the balance? Refundable on prepayment? Is unearned add-on interest rebated?
**A:** Confirmed. The origination fee is 0.5% × term months (1.5% for 3-month, 3% for 6-month, 6% for 12-month terms) and the add-on rate is 1% of original principal per month, flat across tenors. There is no cash disbursement — an installment plan converts an existing card purchase — so nothing is netted: the origination fee is charged to the account and billed on the statement. If a plan is terminated in the first month, the origination fee is reversed and no cancellation fee applies; after the first month, the origination fee is retained and a cancellation fee equal to the current month's interest is charged. Add-on interest is billed monthly only while the plan is active, so unearned interest for remaining months is never charged (no rebate needed).
**Note (internal):** Fund email 2026-08-26, item 4. Verified against all 4,974 plans in `Installment Tape_20260814.xlsx` (see METHODS.md): upfront/principal exactly 0.5% × months; monthly interest/principal exactly 1.0% on 4,897 plans; 77 plans show 0% interest — [Steve: promo plans? worth knowing before the fund asks]. Consistent with the 2.1 response already sent.

### 5 Revenue fields absent from the tape [Open]
**Q:** The tape shows late fees and installment fees but no interchange, annual fee, upfront fee, cash advance fee, etc. Is that because those revenues do not attach to the receivable, or because they were excluded from the extract?
**A:** [partial draft:] Interchange is earned on the merchant/network side of each transaction and never posts to the cardholder account, so it does not appear in a receivables tape. [Steve: confirm which of the other fee types exist at all as Zed products (annual fee? cash advance?) — the honest answer may simply be that these products don't exist — and whether anything that does bill to cardholders was excluded from the extract.]
**Note (internal):** Fund email 2026-08-26, item 5. Ties to item 3 — answer both together once the extract's contents are confirmed.

### 6 Net interchange as % of GMV [Open]
**Q:** Net interchange as a percentage of GMV for the last six months, split domestic vs international if possible.
**A:** To be provided.
**Note (internal):** Fund email 2026-08-26, item 6. Candidate BigQuery pull — needs Steve's sign-off on definitions before running (net of network + processor costs? which GMV base? is the domestic/international split available in our data?). Unit econ file shows interchange only bundled with installment interest and fees ($6.41/account/mo), so this is a new cut.

### 7 BSP rate ceilings and pricing headroom [Open]
**Q:** Both the revolving rate (3%/month) and installment add-on (1%/month) sit exactly at the BSP ceilings. Confirm there is no pricing headroom, and what happens to program economics if BSP cuts the ceiling at a semiannual review.
**A:** [partial draft:] Confirmed — our revolving rate is 3% per month and the installment add-on is 1% per month, at the current BSP ceilings. [Steve: the sensitivity answer — impact on program economics of a ceiling cut, and any mitigants (fee mix, funding cost, underwriting).]
**Note (internal):** Fund email 2026-08-26, item 7. Rates verified (1.2 as sent; installment tape per METHODS.md); on the 8/12 call we already told them "all at regulatory maximums" (3%/mo ≈ 36.5% APR), so "confirmed" is consistent. The headroom/sensitivity narrative is strategy — Steve's voice required. Consider whether the unit econ pro forma should be the quantitative backbone of the answer.

### 8 Loss figure basis, charge-off policy, restructures [Open]
**Q:** What's the basis for the ~2% loss figure provided (30+/90+ DPD, annualized NCL, cumulative) and its denominator? Charge-off policy in DPD, any change since launch, and approach to restructures/re-aging.
**A:** The ~2% figure is our headline default metric as discussed on our call: dollars originated that go past due, i.e. past-due originated volume over cumulative originated volume — not an annualized NCL rate. We manage to a 1–3% target range and are currently at ~2%, in line with US prime credit card benchmarks. [Steve/Claude: confirm the exact DPD threshold and computation against the warehouse before sending.] On policy: per our ECL policy we provision 100% at 180+ DPD; we have not yet formally written off balances while we stand up the collections-substantiation and BIR documentation required, and the policy is unchanged since launch. Re-aging to Current requires all arrears cleared. [Steve: whether any restructure program exists.]
**Note (internal):** Fund email 2026-08-26, item 8. Basis grounded in the 8/12 call notes ("dollars originated that go past due; target 1–3%, currently ~2%, in line with US prime benchmarks") — the fund heard this live, so the written answer must match it. The exact computation (DPD threshold, as-of date, cumulative vs cohort) is not specified in the notes; verify in BigQuery and record in METHODS.md before approving. Distinct from the unit econ provision line (~49% of gross revenue per active account) — if the fund juxtaposes the two, the reconciliation is originated-volume denominator vs revenue denominator.

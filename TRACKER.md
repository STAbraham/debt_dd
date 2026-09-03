# Diligence Tracker

**Status:** v13 — all 14 initial-doc items closed. Live work is the 8/26 email batch, now items 6–13: Drafted 6.1, 6.2, 7, 9.1–9.3, 12.1, 13.2 · Open 8, 10, 11, 12.2, 13.1, 13.3. Installment Funds Flow diagram staged in Data Room / Product (Box upload pending).
**This file is the source of truth.** The outbound spreadsheet is generated from it via `scripts/export_responses.py`; Steve reviews in `WORKING - Diligence Responses.xlsx`. Lines marked `**Note (internal):**` are never exported.
**ID convention:** one running scheme across all batches. The initial doc's five sections became 1.1–5.3. In later fund emails, each bullet takes the next top-level number (8/26 email bullets 1–8 → items 6–13); a bullet containing several distinct questions splits into .1/.2/.3 sub-items. Questions are quoted **verbatim** from the fund's email, keeping the fund's own bullet number at the start of the text ("8 (cont.):" marks the continuation of a split bullet) — so the sheet maps 1:1 to their email while our IDs stay unambiguous against earlier references like 1.2. IDs never change once a response sheet containing them has been sent.

**Changelog**
- **v13 (2026-09-02):** Item 7 opener recalibrated per Steve — "Happy to walk through this" was too soft; now "To frame this walkthrough:" followed by the facts stated plainly. Skill tone rule updated with the calibrated middle.
- **v12 (2026-09-02):** Softened item 7's opening per Steve — the premise correction now reads as gracious context-setting ("Happy to walk through this…") rather than a rebuttal; same facts. Tone rule added to the skill: correct fund misunderstandings helpfully, confident but never combative.
- **v11 (2026-09-02):** Item 7 missed-payment paragraph refined per Steve's i2c screenshot: the ₱1,000 late payment penalty bills only if payment hasn't been made within the 2-day late-payment grace period after the due date (i2c program config Zed_Card_NNB → Credit Card Rules → Statement). Freeze at DPD 1 unchanged; the CS guide's "penalty timing pending" flag is resolved.
- **v10 (2026-09-02):** Rewrote item 7 per Steve: corrected FPF's implicit assumption that "pay in full" is a separate product (charge card deprecated — revolving launched 5/25, MPD statements from 6/1, final charge-card cohort transitioned 6/15, 100% of base on revolving; paying in full is a behavior, not a SKU), then added a from-first-principles revolving explainer grounded in the internal Revolving Credit Card Support Guide (Notion): statement cycle and MPD, grace period and exactly how it's lost, daily 0.1% adjusted-daily-balance interest from statement cut-off with worked example, residual interest, grace regain, missed-payment/₱1,000 late penalty, installment interaction.
- **v9 (2026-09-02):** Renumbered the 8/26 batch to continue the tracker's running numbering, per Steve (supersedes v4's email-native 1–8, which collided with references to earlier items like 1.2): each email bullet takes the next top-level number (bullets 1–8 → items 6–13), and multi-part bullets split as .1/.2/.3 — 6.1/6.2 (economics vs flow of funds), 9.1–9.3 (fee schedule: rates / netted-vs-financed / prepayment-rebate), 12.1/12.2 (ceiling confirmation vs cut sensitivity), 13.1–13.3 (loss basis / charge-off policy / restructures). Questions now quoted verbatim from Raymond's email with the email's own bullet numbers kept at the start of each question. Safe to renumber — no response sheet with the interim IDs was ever sent. Splits let confirmed halves carry Drafted while open halves stay Open (12.1 vs 12.2, 13.2 vs 13.3).
- **v8 (2026-09-02):** Built the Installment Funds Flow diagram with Steve (iterated live: four-party lane order, Part 1 Purchase / Part 2 Post-Purchase split, his confirmations on first-billing timing, monthly billing composition, single-entity balance-sheet funding). Rendered to PDF → `Data Room/Product/Installment Funds Flow_20260902.pdf` (Box upload pending). Items 1 and 2: flow-of-funds placeholders replaced with diagram pointers; synced Steve's two wording edits to item 1 from the working sheet ("Upon enrollment:" lead-in, comma removal).
- **v7 (2026-09-01):** Corrected item 1 per Steve: installment enrollment happens post-purchase (AmEx Pay-Over-Time-style), never at swipe, and purchases are eligible only during the statement cycle in which they were made. Item 2's opening reworded to match.
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

## 6. Follow-up questions (fund email 2026-08-26 — bullets 1–8 → items 6–13; multi-part bullets split as .1/.2/.3)

### 6.1 Installment purchase — economics walkthrough [Drafted]
**Q:** 1. Could you walk us through the economics of a typical installment purchase, from the swipe through to final payment? We're mainly after the revenue lines and their timing: what you earn on the transaction itself (interchange, net of network and processor costs), what's charged upfront at origination, and what accrues over the term.
**A:** At the swipe, there is no installment dimension yet: the user simply makes a purchase, and Zed earns interchange on it like any other transaction (net interchange economics covered in 11). Our installment feature works much like AmEx's "Pay Over Time": after the purchase, certain transactions are eligible for installment enrollment and a purchase is only eligible during the statement cycle in which it was made. If the user enrolls an eligible purchase into installments, the dynamics below follow.

Upon enrollment: an upfront fee of 0.5% × term months (1.5% / 3% / 6% for the 3 / 6 / 12-month terms, respectively) is charged to the account and billed in its entirety in the statement cycle in which the purchase was enrolled.

Over the term: add-on interest of 1% × original principal is billed on each monthly statement — so by end of term, total interest of 3% / 6% / 12% of principal has been charged for the 3 / 6 / 12-month terms.

Early termination: a cancellation fee equal to the current statement cycle's interest is charged and the upfront fee is retained, with one exception — if a purchase is enrolled into installments and cancelled within that same first statement cycle, we charge no interest and reverse the upfront fee. Nothing has been billed at that point and the user hasn't yet floated any of the purchase via installments, so we treat it as a foot fault and allow them to unwind the enrollment without any implications.
**Note (internal):** Fund email 2026-08-26, bullet 1 (economics half; flow of funds split to 6.2). Steve's own explanation (working-sheet syncs 2026-09-01/02), restructured per his notes: enrollment is post-purchase (AmEx Pay-Over-Time-style) — at swipe there is no installment attribute, and eligibility lasts only for the purchase's statement cycle. Fee mechanics verified against the installment tape (see METHODS.md).

### 6.2 Installment purchase — flow of funds [Drafted]
**Q:** 1 (cont.): Plus the flow of funds: who pays whom, when, and which entity each flow lands in.
**A:** See the Installment Funds Flow diagram in Data Room / Product. In short: at purchase, Zed funds the merchant T+1 through Mastercard from its own balance sheet (we have no bank funding partner) and earns interchange; every flow after that is between the customer and Zed — the upfront fee and the first 1/X billing land on the enrollment-cycle statement, and each statement's installment billing converts back to revolving balance and must be paid in full by that cycle's due date under our Minimum Payment Due rules.
**Note (internal):** Fund email 2026-08-26, bullet 1 (flow-of-funds half). Resolved 2026-09-02 by the diagram, built collaboratively with Steve; his confirmations: first 1/X bills in the enrollment cycle alongside the fee; monthly billing = 1/X + 1% add-on; single-entity issuer funded off Zed's own balance sheet, no bank partner; acquirer collapsed into the network rail; early termination as footnote only. PDF not yet uploaded to Box — SHARED-LOG row waits for Steve's confirmation.

### 7 Revolver and pay-in-full — economics walkthrough [Drafted]
**Q:** 2. Do the same walkthrough for a revolving balance and for a pay-in-full statement, so we can see how the three products differ economically.
**A:** To frame this walkthrough: today, "pay in full" and "revolving" are two payment behaviors on the same card rather than separate products. Paying in full was the required dynamic of our original charge card, which we have since retired. We launched revolving on May 25th; the first statements carrying a Minimum Payment Due below the statement ending balance were generated June 1, and the second and final cohort of users still on the charge-card dynamic (where the MPD equaled the statement ending balance) transitioned on June 15. Since then, our entire customer base is on the revolving product. Cardholders can of course still choose to pay their balance in full each cycle to avoid interest — like any credit card — it's simply no longer required. So the walkthrough below covers one card product (a revolving credit card with an installment feature) in its different payment modes.

Interchange: as in 6.1, every purchase earns Zed interchange at the swipe — payment behavior plays out afterwards and never changes the transaction-level economics.

How revolving works, from first principles:

Statement cycle: purchases post to the balance through the cycle; at cycle close we generate a statement fixing the statement balance, the Minimum Payment Due (formula per our response to 1.2 — in short, 100% of billed installment amounts, late fees and past-due amounts, plus 10% of the remaining statement balance, floored at ₱1,000), and the payment due date.

Grace period — the pay-in-full behavior: if the cardholder paid the prior statement in full, no interest accrues on purchases through the due date. A cardholder who pays the statement balance in full by the due date every cycle never pays interest; Zed's economics on these users are interchange only.

Losing the grace period: paying anything less than the full statement balance by the due date — even well above the MPD — ends the grace period. From that point interest accrues daily on the unpaid balance starting from the statement cut-off date (day 1 of interest is the statement day itself), and the accrued interest is billed on the next statement.

How interest is computed: 3% per month, accrued daily at 0.1%/day on the adjusted daily balance (we use the 30-day banking standard for the daily rate, so a 31-day month accrues 3.1% and a 28-day month 2.8%). Payments reduce the accruing balance the day they post. Example: a cardholder who has lost their grace period carries a ₱1,000 statement balance; they pay ₱250 on day 11 and nothing else; interest accrues on ₱1,000 for days 1–10 and on ₱750 for days 11–30, and the summed daily interest is billed on the next statement.

Residual interest: once the grace period is lost, paying the balance in full mid-cycle stops accrual going forward, but the interest already accrued for the days the balance existed still bills on the following statement.

Regaining the grace period: pay the total balance in full by the payment due date; the grace period resumes from the following billing cycle.

Missed payment: if the MPD is not met by the due date, the account is past due and a hard card freeze applies at DPD 1 (per our response to 1.4). A ₱1,000 late payment penalty is charged if payment still has not been made within the 2-day late-payment grace period following the due date. Interest continues to accrue on the unpaid balance while delinquent, and the past-due amount includes accrued finance charges.

Installment interaction, for completeness: billed installment amounts accrue no interest for cardholders whose grace period is intact; once the grace period is lost, they accrue daily interest from the statement date until paid — consistent with the billed-installment-converts-to-revolving mechanics in 6.1/6.2.

Flow of funds: the purchase-side flow (merchant settlement, interchange, Zed funding from its own balance sheet) is identical for all payment behaviors — see the Installment Funds Flow diagram in Data Room / Product, Part 1. For revolvers and full payers, everything after settlement is simply the customer paying Zed against the monthly statement.
**Note (internal):** Fund email 2026-08-26, bullet 2. Rewritten 2026-09-02 per Steve: FPF appeared to assume pay-in-full is a separate SKU — the correction (charge card deprecated; June 1 / June 15 transition; 100% on revolving) leads the answer and matches 1.1 as sent. Revolving mechanics sourced from the internal "Revolving Credit Card Support Guide" (Notion / Customer Success, last edited 2026-08-13): grace-period loss/regain, daily 0.1% adjusted-daily-balance accrual from statement cut-off, residual interest, ₱1,000 late payment penalty. Flags: (a) the ₱1,000 late penalty was not in any sent response and is distinct from 1.2's ₱1,000 MPD floor — don't conflate; (b) penalty timing confirmed 2026-09-02 from the i2c program config (Zed_Card_NNB, Credit Card Rules → Statement, screenshot from Steve): Late Payment Grace Period = 2 days after the due date — resolves the guide's "timing pending"; the i2c Delinquency Grace Period field appears unset, consistent with freeze at DPD 1; (c) 1.2-sent line "only charges after revolving launched were able to revolve" is superseded by the fuller transition narrative — consistent, since pre-transition statements required full payment. Call-context figures (33%/7%/10% mix) still unverified — keep out of written responses. Flow-of-funds gap resolved via the same diagram as 6.2.

### 8 "Installment fees" field definition [Open]
**Q:** 3. Define what the "installment fees" field in the tape contains: the upfront origination fee, the monthly add-on interest, or both combined.
**A:** To be provided.
**Note (internal):** Fund email 2026-08-26, bullet 3. Do not draft from inference — the answer depends on how the tape extract was built. Verify empirically (trace plans from the installment tape into their statement-tape rows, and/or against the warehouse) or confirm with whoever built the extract (Josif?), then write the definition. Verification pending — see METHODS.md.

### 9.1 Fee schedule — rates and formula [Drafted]
**Q:** 4. Confirm the fee schedule: add-on rate by tenor, and the origination fee formula. We have been told 0.5% × number of months (3% on a 6-month term). Confirm or correct.
**A:** Confirmed. The origination fee is 0.5% × term months (1.5% for 3-month, 3% for 6-month, 6% for 12-month terms) and the add-on rate is 1% of original principal per month, flat across tenors.
**Note (internal):** Fund email 2026-08-26, bullet 4. Verified against all 4,974 plans in `Installment Tape_20260814.xlsx` (see METHODS.md): upfront/principal exactly 0.5% × months; monthly interest/principal exactly 1.0% on 4,897 plans; 77 plans show 0% interest — [Steve: promo plans? worth knowing before the fund asks]. Consistent with the 2.1 response already sent.

### 9.2 Fee schedule — netted vs financed [Drafted]
**Q:** 4 (cont.): Is the fee netted from the disbursement or financed into the balance?
**A:** There is no cash disbursement — an installment plan converts an existing card purchase — so nothing is netted: the origination fee is charged to the account and billed on the statement.
**Note (internal):** Fund email 2026-08-26, bullet 4. See 9.1's verification note.

### 9.3 Fee schedule — prepayment refund and interest rebate [Drafted]
**Q:** 4 (cont.): Is it refundable on prepayment, and is unearned add-on interest rebated?
**A:** If a plan is terminated in the first month, the origination fee is reversed and no cancellation fee applies; after the first month, the origination fee is retained and a cancellation fee equal to the current month's interest is charged. Add-on interest is billed monthly only while the plan is active, so unearned interest for remaining months is never charged (no rebate needed).
**Note (internal):** Fund email 2026-08-26, bullet 4. Cancellation mechanics per Steve's 6.1 walkthrough; consistent with the funds-flow diagram footnote.

### 10 Revenue fields absent from the tape [Open]
**Q:** 5. The tape shows late fees and installment fees but no interchange, no annual fee, no upfront fee, no cash advance fee, etc. Is that because those revenues do not attach to the receivable, or because they were excluded from the extract?
**A:** [partial draft:] Interchange is earned on the merchant/network side of each transaction and never posts to the cardholder account, so it does not appear in a receivables tape. [Steve: confirm which of the other fee types exist at all as Zed products (annual fee? cash advance?) — the honest answer may simply be that these products don't exist — and whether anything that does bill to cardholders was excluded from the extract.]
**Note (internal):** Fund email 2026-08-26, bullet 5. Ties to 8 — answer both together once the extract's contents are confirmed.

### 11 Net interchange as % of GMV [Open]
**Q:** 6. What is your net interchange as a percentage of GMV for the last six months (if possible, split domestic vs international)?
**A:** To be provided.
**Note (internal):** Fund email 2026-08-26, bullet 6. Candidate BigQuery pull — needs Steve's sign-off on definitions before running (net of network + processor costs? which GMV base? is the domestic/international split available in our data?). Unit econ file shows interchange only bundled with installment interest and fees ($6.41/account/mo), so this is a new cut.

### 12.1 BSP ceilings — headroom confirmation [Drafted]
**Q:** 7. Both your revolving rate (3%/month) and installment add-on (1%/month) sit exactly at the BSP ceilings. Confirm there is no pricing headroom.
**A:** Confirmed — our revolving rate is 3% per month and the installment add-on is 1% per month, at the current BSP ceilings.
**Note (internal):** Fund email 2026-08-26, bullet 7 (confirmation half). Rates verified (1.2 as sent; installment tape per METHODS.md); on the 8/12 call we already told them "all at regulatory maximums" (3%/mo ≈ 36.5% APR), so "confirmed" is consistent.

### 12.2 BSP ceilings — cut sensitivity [Open]
**Q:** 7 (cont.): …and tell us what happens to program economics if BSP cuts the ceiling at a semiannual review.
**A:** [Steve: the sensitivity answer — impact on program economics of a ceiling cut, and any mitigants (fee mix, funding cost, underwriting).]
**Note (internal):** Fund email 2026-08-26, bullet 7 (sensitivity half). The headroom/sensitivity narrative is strategy — Steve's voice required. Consider whether the unit econ pro forma should be the quantitative backbone of the answer.

### 13.1 Loss figure — basis and denominator [Open]
**Q:** 8. What's the basis for the ~2% loss figure provided (30+/90+ DPD, annualized NCL, cumulative) and its denominator?
**A:** The ~2% figure is our headline default metric as discussed on our call: dollars originated that go past due, i.e. past-due originated volume over cumulative originated volume — not an annualized NCL rate. We manage to a 1–3% target range and are currently at ~2%, in line with US prime credit card benchmarks. [Steve/Claude: confirm the exact DPD threshold and computation against the warehouse before sending.]
**Note (internal):** Fund email 2026-08-26, bullet 8 (basis half). Grounded in the 8/12 call notes ("dollars originated that go past due; target 1–3%, currently ~2%, in line with US prime benchmarks") — the fund heard this live, so the written answer must match it. The exact computation (DPD threshold, as-of date, cumulative vs cohort) is not specified in the notes; verify in BigQuery and record in METHODS.md before approving. Distinct from the unit econ provision line (~49% of gross revenue per active account) — if the fund juxtaposes the two, the reconciliation is originated-volume denominator vs revenue denominator.

### 13.2 Charge-off policy and changes since launch [Drafted]
**Q:** 8 (cont.): We'd also appreciate your charge-off policy in DPD, and any change to it since launch.
**A:** Per our ECL policy we provision 100% at 180+ DPD; we have not yet formally written off balances while we stand up the collections-substantiation and BIR documentation required, and the policy is unchanged since launch.
**Note (internal):** Fund email 2026-08-26, bullet 8 (policy half). Drafted 2026-09-01 from the 8/12 call context; review wording with Steve before approving.

### 13.3 Restructures and re-aging [Open]
**Q:** 8 (cont.): …and your approach to restructures/re-aging.
**A:** Re-aging to Current requires all arrears cleared. [Steve: whether any restructure program exists.]
**Note (internal):** Fund email 2026-08-26, bullet 8 (restructures half). Restructure-program existence is unconfirmed — do not answer without Steve.

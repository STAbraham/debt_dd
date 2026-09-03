# Methods — internal record of how data artifacts and analyses were produced

**Internal only, never shared.** One entry per produced artifact or load-bearing analysis: sources (tables/files/queries), filters, as-of date, caveats, and who reviewed it. Written the same turn the work is done. SHARED-LOG rows for produced artifacts should point at their entry here.

---

## 2026-09-01 — Installment fee schedule verification (analysis; backs 8/26 items 4, 1, 7)

**Question:** Confirm the origination-fee formula and add-on rate the fund asked about (their 8/26 items 4 and 7).
**Source:** `Data Room/Loan Tape/Installment Tape_20260814.xlsx`, sheet `Installment-Tape` (the artifact the fund holds — emailed 2026-08-21). Deduped to 4,974 unique plans by `Original Transaction Id`, taking each plan's first row (the one carrying Tenure and Upfront Fee rate).
**Method:** For each plan, computed `Interest for each month / Principal Amount` and read the upfront-fee rate column against Tenure.
**Findings:**
- Upfront fee rate is exactly 0.5% × term months for **all** plans: 1.5% ('3 mo.', n=2,117), 3% ('6 mo.', n=1,630), 6% ('12 mo.', n=1,227).
- Monthly add-on interest is exactly 1.0% of original principal for 4,897 plans; **77 plans show 0%** — unexplained (promo?), flagged to Steve in 8/26 item 4's internal note.
**Caveats:** Verified against the shared extract, not the warehouse; the peso upfront-fee amount sits in a second, unlabeled duplicate column (e.g. ‑82.35 = 5,490 × 1.5%) charged in plan month 1.
**Reviewed by:** pending Steve.

## 2026-09-02 — Installment Funds Flow diagram (produced artifact; answers the flow-of-funds half of 8/26 items 1–2)

**Artifact:** `Data Room/Product/Installment Funds Flow_20260902.pdf` (2 pages: swimlane diagram + cash summary). Source of truth for regeneration: HTML in the session scratchpad (`funds-flow-item1-print.html`), rendered via headless Chrome print-to-PDF.
**Content basis:** Steve's walkthroughs in this session and the working sheet — post-purchase Pay-Over-Time-style enrollment, four-party purchase flow (swipe at merchant → auth via Mastercard → Zed approves → T+1 settlement), MPD includes the full installment billing, revolving-interest accrual on billed installments for revolvers. Steve's explicit confirmations: first 1/X bills on the enrollment-cycle statement alongside the upfront fee; monthly billing = 1/X principal + 1% add-on; Zed is a single issuing entity funding settlement from its own balance sheet (no bank funding partner); acquirer collapsed into the Mastercard rail; early termination footnote only.
**Numbers:** worked example ₱12,000 × 6 months — fee/interest rates from the 2026-09-01 installment-tape verification (entry above): 3% upfront (₱360), 1%/mo add-on (₱120), totals ₱2,480 first statement, 5 × ₱2,120, ₱13,080 collected (9.0% finance charge). Revolving 3%/mo and DPD-1 freeze per 1.2/1.4 as sent.
**Caveats:** T+1 settlement timing and "net of MDR / net of interchange" framing are Steve's description, not independently verified. Not yet uploaded to Box — SHARED-LOG row pending Steve's confirmation.
**Reviewed by:** Steve (iterated live in this session; content approved before PDF render).

## 2026-09-03 — Interchange data does NOT exist in the warehouse (negative finding; scopes item 11)

**Question:** Can item 11 (net interchange % of GMV) be answered from BigQuery? Steve suspected not.
**Method:** Scanned `epicac-2.epicac_prod_direct.INFORMATION_SCHEMA.COLUMNS` across all 62 tables for `%interchange%`, `%mdr%`, and settlement/revenue/fee/network table names; inspected fee/amount/settlement columns on `public_transactions` and `public_network_messages`.
**Finding:** No interchange, MDR, or settlement-fee field anywhere. Transaction tables carry only gross amounts (`amount`, `amount_requested`). Consistent with the warehouse being a CDC mirror of the app Postgres DB — interchange is earned on the network/settlement side and never posts to cardholder accounts. Only fee-adjacent tables: `public_late_payment_fees`, `public_network_messages` (auth messages, no economics).
**Implication:** Item 11's numerator must come from i2c/Mastercard settlement reporting or finance records; BQ can only supply the GMV denominator once the base is defined.
**Reviewed by:** pending Steve.

## Open verification (started, not finished)

- **8/26 item 3 — what the statement tape's "Installment Fees" column contains** (upfront only vs upfront + monthly add-on): plan-to-statement trace was queued when the 2026-09-01 session paused; per Steve, use BigQuery as the source of truth and/or confirm with whoever built the extract. Record the result here when done.

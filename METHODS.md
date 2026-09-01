# Methods — internal record of how data artifacts and analyses were produced

**Internal only, never shared.** One entry per produced artifact or load-bearing analysis: sources (tables/files/queries), filters, as-of date, caveats, and who reviewed it. Written the same turn the work is done. SHARED-LOG rows for produced artifacts should point at their entry here.

---

## 2026-09-01 — Installment fee schedule verification (analysis; backs 6.4, 6.1, 6.7)

**Question:** Confirm the origination-fee formula and add-on rate the fund asked about (their 8/26 items 4 and 7).
**Source:** `Data Room/Loan Tape/Installment Tape_20260814.xlsx`, sheet `Installment-Tape` (the artifact the fund holds — emailed 2026-08-21). Deduped to 4,974 unique plans by `Original Transaction Id`, taking each plan's first row (the one carrying Tenure and Upfront Fee rate).
**Method:** For each plan, computed `Interest for each month / Principal Amount` and read the upfront-fee rate column against Tenure.
**Findings:**
- Upfront fee rate is exactly 0.5% × term months for **all** plans: 1.5% ('3 mo.', n=2,117), 3% ('6 mo.', n=1,630), 6% ('12 mo.', n=1,227).
- Monthly add-on interest is exactly 1.0% of original principal for 4,897 plans; **77 plans show 0%** — unexplained (promo?), flagged to Steve in 6.4's internal note.
**Caveats:** Verified against the shared extract, not the warehouse; the peso upfront-fee amount sits in a second, unlabeled duplicate column (e.g. ‑82.35 = 5,490 × 1.5%) charged in plan month 1.
**Reviewed by:** pending Steve.

## Open verification (started, not finished)

- **6.3 — what the statement tape's "Installment Fees" column contains** (upfront only vs upfront + monthly add-on): plan-to-statement trace was queued when the 2026-09-01 session paused; per Steve, use BigQuery as the source of truth and/or confirm with whoever built the extract. Record the result here when done.

# Tape diff — FPF room (as of 7/31) vs Accial room (as of 8/31), read-only, 2026-10-18

**Files:** `Data Room (FPF)/Payment Data/Statement Tape_20260731.xlsx` (59,362 statements, cycles To ≤ 2026-06-30) vs `Data Room (Accial)/Payment Data/Statement Tape 20260831.xlsm` (sheet `statement_tape_20260831_v2`, 70,142 statements, To ≤ 2026-08-01, header on row 10); `Loan Tape/Cardholder Tape_20260731.xlsx` (12,469 users) vs `Cardholder Tape_20260831.xlsx` (13,319). Method: openpyxl, join on (User ID, From, To) / User ID; 58,705 statements and all 12,469 FPF users overlap. Steve's expectation: "only timing, plus summary metrics up top." Result: structure matches that; values do not.

## Statement tape

**Structure — as expected.** Same 19 columns in the same order; Accial adds `Customer Statement Count` (1–32) and `First Month Delinquent Loans Uncured` (0/1; 211 ones), plus a 9-row summary block that reconciles exactly to the data: 49,123 statements with Purchase Charges > 0; 2,667 with Worst Status PD*; −211 first-month uncured ("normalizing for anomalous behaviour (fraud)"); 2,456 / 49,123 = 5.00% ever past due; 1,875 cured = 76.3% cure rate; net 581 = 1.19%.

**Timing — as expected.** 11,436 Accial-only statements are the July cycles (To 2026-07-01…08-01) that post-date the FPF cut. Identical on overlap: Due, Purchase Charges, Installment Conversions, Installment Cancellations, Interest, Total Statement Charges, Credits, Statement Balance, Installment Balance (0 mismatches each; sums equal to the peso).

**Not timing — four methodology differences on the 58,705 overlapping statements:**

1. **₱1,000 late fees reclassified out of Installment Fees (474 statements).** In the FPF tape these sit in `Installment Fees`; in Accial's they sit in `Late Fees` (460 are exact 1:1 moves of ₱1,000). Late Fees total 2,489,664 → 2,963,664 (+19%); Installment Fees 1,871,488 → 1,375,047 (−27%); Total Statement Charges unchanged. **FPF's tape overstates installment fees and understates late fees by ₱474K.**
2. **Termination fees moved from Installment Fees to Installment Charges (142 statements, ₱22,442).** Example: user 00c5cd96… cycle 2026-01-19→03-31: Installment Fees 130.13 → 78.08, Installment Charges 0 → 52.05. The new build treats the final-cycle "termination fee" as interest — which is what item 8 told FPF it economically is, while also telling FPF the field *contains* it. **Item 8's field definition as sent to FPF no longer matches the current build.**
3. **Status relabeling — new value "No new statement charges".** Effective Status differs on 17,406 statements (29.7%): 14,465 "Paid" → "No new statement charges" (zero-charge cycles; 14,979 of the 17,014 relabeled rows have Total Statement Charges = 0) — cosmetic. But also **658 "PD 180+", 426 "PD 1-30", 361 "PD 30-60", 320 "PD 60-90", 312 "PD 150-180", 298 "PD 90-120", 174 "PD 120-150" → "No new statement charges"**; Worst Status likewise moves 1,431 PD-labelled statements (382 of them PD 180+) to "No new statement charges". A delinquent account's zero-charge statement is no longer labelled delinquent at statement level; delinquency must be read from the cardholder tape. Effective-Status PD* count on the overlap drops accordingly (Accial tape: 792 Effective PD* vs 2,667 Worst PD*). Remaining shifts (PD 150-180 → PD 180+: 103; PD 30-60 → PD 60-90: 79; …) are aging to a later report date — timing.
4. **657 statements removed (103 users; 76 users gone entirely, 27 partially).** Dropped rows: 553 "Paid on time", ₱15.5M charges / ₱13.6M credits / ₱12.1M balances; cycles from 2024-09 to 2026-06-30. Example user 008cd8c0…: FPF has Aug-2025→Feb-2026 cycles, Accial keeps only the first. **Rationale not in any document — Steve to say (closed/test/employee/fraud/duplicate cycles?).** FPF's tape contains statements Zed's current build excludes.

Minor: `Payment Plan` flips on 47 statements (32 Yes→No, 15 No→Yes), none with an installment balance.

## Cardholder tape

**Structure identical** (7 columns). All 12,469 FPF users present in Accial's tape; 850 new users originated 2026-07-31…08-28 — timing. Origination dates identical. Status mix moved with aging (PD 180+ 251 → 302).

**Credit limits: 5,705 of 12,469 users (45.8%) have a HIGHER limit on 8/31 than on 7/31; 1 lower.** Moves are one rung up the limit ladder (15k→25k ×1,136; 25k→35k ×668; 50k→65k ×640; 35k→50k ×635; 150k→175k ×417 …). Total limits on the overlapping users 846.0M → 923.7M (+9.2%). Only 2 of the 5,706 changes are on non-Current accounts. This reads as a **programme-wide limit re-leveling in August 2026**, not a methodology change — **Steve to confirm.** FPF has not seen it (their tape is 7/31); it is material to any lender's exposure/utilisation view and to item 3.2 (re-leveling guardrails) as answered.

## Implications

- Steve's rule (2026-10-18): the Accial data is the most accurate; FPF's tapes are superseded. FPF therefore holds (a) ₱474K of late fees mislabelled as installment fees, (b) a field definition for "installment fees" (item 8) that the current build no longer follows, (c) 657 statements the current build excludes, and (d) no view of the August re-leveling. None of this changes Total Statement Charges, balances or interest — the headline economics are intact — but any FPF analysis of fee mix or statement-level delinquency is off.
- Decide whether to (i) proactively refresh FPF's room with the 8/31 tapes (same files Accial holds) and a one-paragraph note on the three definitional changes, or (ii) wait for FPF's terms. If FPF's IC is live, a silent gap between what the two funds hold is the worse outcome.
- Tracker items affected: 8 (field definition), 2.1 (the "~3.2% blended installment charges … includes upfront fees and current month interest (cancellation fee)" figure was computed on the old build — recompute on the Accial tape before reuse), 3.2 (re-leveling), and the status-definition language in 7/1.4 if statement-level delinquency is quoted anywhere.

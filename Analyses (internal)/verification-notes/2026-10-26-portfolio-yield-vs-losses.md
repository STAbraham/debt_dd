# Portfolio yield vs losses on a receivables basis — 2026-10-26 (internal; answers "is there enough net yield to carry high-teens cost of funds?")

Source: KPI Dashboard snapshot 2026-10-26 (Monthly tab, PHP rows 40/42/49/52/53/55 revenue; 67 avg loans outstanding; 65 EOM receivables; 74/83/84 delinquency buckets; 85 charge-offs; 127 settlement volume). All yields annualized on AVERAGE receivables (r67). FX 55.8.

## Gross yield on receivables

| Window | Avg receivables | Turnover (settlement ÷ avg rec, annualized) | Revolving int. | Installment int.+fees | Late fees | **Balance-driven yield** | Interchange | **All-revenue yield** |
|---|---|---|---|---|---|---|---|---|
| Sep 2026 | ₱211M ($3.8M) | 10.8x | 12.7% | 5.3% | 0.7% | **18.7%** | 15.0% | **33.6%** |
| Q3 2026 | ₱182M | 9.9x | 12.5% | 5.3% | 0.7% | **18.5%** | 13.9% | **32.4%** |
| T6 Apr–Sep | ₱154M | 10.4x | 8.3% | 5.5% | 0.9% | **14.6%** | 14.8% | **29.4%** |
| T12 Oct25–Sep26 | ₱107M | 11.3x | 6.0% | 4.5% | 1.0% | **11.5%** | 16.2% | **27.7%** |

Revolving launched late June, so the Sep run-rate is the relevant forward number; T12 understates it.

## Loss on receivables — proxies only (no provision line in the dashboard; charge-offs still 0)

- 181+ bucket growth, annualized on avg receivables: 12.2% (Jun→Sep), 16.3% (Mar→Sep), 14.8% (Sep25→Sep26). 151+ bucket: 12.8% / 17.2% / 16.5%. Because nothing is written off, bucket growth = gross roll into terminal delinquency, before any recoveries.
- Volume-based loss rates translated to balances via turnover (~11x): 1.87% lifetime past-due → 21% of avg receivables/yr (upper bound: includes cures); 1.19% net after cures (Accial tape summary) → 13.5%; 0.66% June-2026 cohort → 7.5%.
- Stock at Sep 2026: DPD30+ ₱21.2M = 9.1% of EOM receivables; 181+ ₱16.2M = 6.9%.
- Working range: **~12–16% of average receivables per year on the book as it is today**, trending toward ~8% if recent cohorts hold at V2-model performance. The 1.87% headline is true and misleading in this context: a transactor-heavy card book turns ~11x a year, so a small loss on originations is a large loss on balances.

## Net yield

- All revenue (incl. interchange) − losses: 33.6% − (12–16%) ≈ **18–22%** before servicing/opex.
- Balance-driven only (what actually flows through pledged collections): 18.7% − (12–16%) ≈ **3–7%**.
- Cost of a high-teens facility (say 17%) at an 80% advance = ~13.6 pts of receivables. Covered only if interchange is counted; not covered by collateral cash flows alone.

## Levers that change the answer (all move together as revolving share rises)

1. Revolving share 26.9% of qualifying users (Sep) → balance-driven yield rises roughly linearly with it (3%/mo on revolving balance = 36% on that slice).
2. Turnover falls as revolvers hold balances (a 50/50 book might turn 4–6x, not 11x) → the same origination loss rate becomes half the loss on balances.
3. Recent-cohort losses (0.66% June) vs lifetime 1.87% — the stock of 181+ is dominated by 2025 V1-model vintages.
4. Interchange: in configuration A it never passes through the collection account; a lender counts it only via a parent guarantee / corporate recourse, not via the collateral waterfall.

Market practice [practice, not documentable]: EM consumer-credit funds underwrite to portfolio net yield after losses materially above cost of funds — commonly framed as excess spread of ≥5–10 points or net-yield coverage of interest ≥1.25–1.5x — and put a cash-trap / early-amortisation trigger on it. Marco's "annualized yield" BOTE is exactly this calculation.

## Addendum 2026-10-26 — reconciliation to Steve's BOE sheet ("BOE Yield", Google Sheet 1FXNnacOu…)

Steve's method: September balances by bucket ($M: installment 0.60 / revolving 1.57 / transacting 1.56 = 3.73), a monthly loan yield + interchange − loss per bucket, balance-weighted, × 12 → 31.89%. Same simple ×12 annualization as mine (no compounding either side). Per-bucket actuals for Sep 2026 (balances report 10/26 + dashboard):

| Bucket | Steve loan yield | Actual | Steve interchange | Actual | Steve loss | Actual (181+ growth ₱1.85M/mo) |
|---|---|---|---|---|---|---|
| Installment (₱33.4M) | 1.50%/mo | 2.77%/mo (1% add-on + upfront fees) | 0.13% | — | 0.07% | ~0 (plans cancel on delinquency) |
| Revolving (₱91.4M) | 5.00%/mo | 2.44%/mo (₱2.23M interest; cap is 3%) | 0.13% | — | 0.07% | 2.02%/mo — ₱17.7M of this bucket is 180+ |
| Transacting (₱83.5M) | 0 | 0 | 1.50%/mo | 3.15%/mo (₱2.63M; balances turn 2.3×/mo) | 0.88%/mo | ~0 (x180 cut removes nothing here) |
| **Blended** | | | | | 0.41%/mo = 4.9%/yr | 0.89%/mo = 10.5%/yr |
| **Net annualized** | **31.9%** | | | | | **22.7%** re-stated; **23.1%** whole-book method (33.6% − 10.5%) |

Differences that matter: (1) 5.00%/mo on revolving is above the 3% cap — actual is 2.44%; (2) interchange on transacting is 3.15%/mo, not 1.50%, because transacting balances turn more than twice a month — but it is still only 1.26%/mo of the whole book; (3) the loss rate is right (0.88%/mo ≈ 181+ growth) but is loaded on the wrong bucket — 180+ balances are revolving by construction, so losses belong on revolving at ~2%/mo, making blended losses ~10.5%/yr not ~5%. Net of all three, the sheet's 31.9% becomes ~23%. Excluding interchange (collateral cash flows only): ~8%.
Denominator note: my earlier 12–16% loss figure annualized bucket growth on the Q3/T6 average book (₱154–182M); on the Sep book (₱211M) the same ₱1.85M/mo is 10.5%. On a book growing ~10%/month the choice of denominator moves the loss rate by several points — state it whenever the number is quoted.

## Correction 2026-10-26 (per Steve) — interchange IS inside pledged collections

Mechanics: Mastercard bills Zed net of interchange (₱98 settled to the merchant on a ₱100 purchase); Zed books and bills the cardholder ₱100; the ₱100 is paid into the collection account. The interchange margin is therefore the excess of collections over the cash cost of creating the receivable — realized at origination and inside the lender's security. The "collateral-only" view above (18.7% − loss − cost → negative excess spread) wrongly treated interchange as a cash stream bypassing collections. The lender's coverage measure is the all-revenue column. The accrual-only split (interest and fees that accrue while balances sit) remains a useful decomposition — it is the part that rises with revolving share — but is not a collateral boundary. A first-facility guarantee compensates for track record, servicer/operational control and young-vintage model risk, not for interchange. Workbook tab renamed "Interchange and the lender" with the ₱100/₱98 walk-through.

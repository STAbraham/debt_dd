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

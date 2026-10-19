# Handoff — facility-structure discussion that happened outside this project

**Provenance:** this note was written 2026-10-01 by a Claude session working in the *stablecoin-project* repo (a different workstream). Steve asked that session a question about this project's "Facility Structure — How to Think About It" doc, and the resulting analysis is summarized here so debt_dd agents have it. **No debt_dd files were modified** by that session; the doc version referenced is `Analyses (internal)/Facility Structure - How to Think About It_v6_20260928.html`.

## The question (Steve, 9/30)

On configuration A's security row — *"ZFPI grants the fund a PPSR-registered lien over a designated receivables pool + control of the collection account, supporting a ZFPI guarantee limited to that collateral (rung 2). Belt-and-braces: parent also assigns the intercompany note. No ZFPI share pledge."* — why are **both** the PPSR lien **and** the assignment of the intercompany note required? Is this double-collateralizing the same loan from the fund?

## The answer given (grounded in v6's own ladder)

Not double-collateralization: two different claims, against two different obligors, that fail in different ways. Recovery across all instruments is capped at the fund's outstandings, so overlap in underlying value affects priority and enforcement path, not quantum. Layered credit support is standard; "belt-and-braces" is the honest label.

Mapped to the chain in configuration A (fund → parent → intercompany note → ZFPI; collections flow back along the same plumbing):

1. **Rung 2 (direct lien + collection-account control) covers ZFPI-level failure.** In-rem, perfected, first-priority claim on the designated pool and the account where collections land (PPSA §48 direct collection / §49 private disposition, no court). But it secures only ZFPI's **collateral-capped guarantee** — if the pool underperforms, the lien is stayed (FRIA Commencement Order) or attacked on perfection, rung 2 is exhausted or delayed and reaches nothing else ZFPI owns.
2. **Rung 3 (assigned intercompany note) covers what the lien doesn't:**
   - **Parent insolvency** — the note is the borrower-parent's principal asset besides the ZFPI shares; unassigned it sits in the parent's estate shared with the parent's other creditors; assigned, the fund steps into the creditor seat against ZFPI even when the entity that failed is its own borrower.
   - **Neutralizing a competing claim** — unassigned, the note is the largest intercompany claim *in ZFPI's creditor queue*, diluting the fund's guarantee claim in a ZFPI insolvency. Assignment folds it into the fund's position — effectively subordinating group paper to the fund. (Lenders take intercompany-receivable assignments for this reason even when they already hold direct security.)
   - **Reach beyond the capped guarantee** — a claim on ZFPI's whole balance sheet up to the note amount, independent of the designated-pool definition.
   - **Control of the payment path** — debt service legally travels along the note (and the note fixes the tax legs: 15% PH withholding up, 0% portfolio interest out); owning it means controlling acceleration and where the stream points.
3. **The complement from v6 §5 itself:** the note *alone* is nearly worthless as security ("pledging the intercompany note to the fund adds nothing unless ZFPI has first secured that note on its receivables" — the Salmon lesson). Hence rung 2 leads, the note is the backup, and the rung 2 + rung 3 pairing is the substitute package that makes "no ZFPI share pledge" (refusing rung 4) sellable.

## Open item flagged for v7 (not yet decided by Steve)

Configuration A should state whether the **assigned note is itself secured on the receivables** (the §5 two-step) **or rides unsecured behind the fund's direct rung-2 lien**:

- *Secured note + direct lien* = two liens on the same pool, both ending up in the fund's hands — harmless but adds PPSR registration mechanics.
- *Unsecured note* = simpler, defensible because the fund already holds the direct lien; the note's value is then the parent-insolvency / queue-neutralization / payment-path roles above, not lien priority.

The stablecoin session offered to note this in v7; Steve had not answered when this handoff was written. Treat it as an open drafting question for the next revision, with counsel input on whether the extra lien is worth the mechanics.

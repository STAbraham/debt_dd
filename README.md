# Zed debt DD — working conventions

Workspace for responding to debt-facility due diligence from credit funds. The `debt-dd` skill (in `~/.claude/skills/debt-dd/`) operates this repo; this README is the contract a fresh session works from.

## Layout

- **`TRACKER.md`** — source of truth for every diligence question: ID, status, question, response. Outbound spreadsheets are *generated* from it (`python3 scripts/export_responses.py [YYYYMMDD]`); `**Note (internal):**` and `**Delivered:**` lines never leave the file.
- **`SHARED-LOG.md`** — provenance ledger: every artifact the fund has received, when, and via which channel. Updated on every share, no exceptions.
- **`METHODS.md`** — internal-only record of how each produced data artifact/analysis was built (sources, queries, filters, caveats, review status), written the same turn the work is done. BigQuery is the source of truth for data questions; risky assumptions get raised to Steve as `[Steve: …]` placeholders instead of being resolved unilaterally.
- **`Data Room/`** — mirror of the **FPF** Box data room (Financials, Loan Tape, Payment Data, Q1 Board Deck, Product). Keep in lockstep with Box: anything uploaded there gets copied here (and vice versa) plus a SHARED-LOG row. The **Accial** room is not mirrored here; its contents are tracked in SHARED-LOG (channel `Data Room (Accial) / …`).
- **Live Box rooms — read-only for Claude:** `~/Box Sync/2025:2026 Debt Processes/Credit Provider Data Room/Data Room (FPF)` and `…/Data Room (Accial)` (opened 2026-09-28). Claude reads them to check what each fund holds and never writes to Box Sync without an explicit instruction for that specific action.
- **`Prior Responses (outside data room)/`** — artifacts shared via email only (non-standard requests we deliberately keep out of the data room).
- **`Diligence Question Responses/`** — archive of outbound response spreadsheets actually sent, dated.
- **`inbox/`** → **`inbox/processed/`** — raw inputs land in the former, move to the latter once propagated.

## How a diligence turn works

1. **Drop raw inputs in `inbox/`** — fund emails with new questions, call notes, raw data pulls, anything. No formatting needed.
2. **Say "process the inbox."** New questions get inventoried into `TRACKER.md` with stable IDs (next number in the matching section, or a new section). Each gets a response channel: tracker text, data-room pointer ("See X in Data Room / Y"), new data-room upload, or email attachment for non-standard asks. Data pulls needed to answer can come from the BigQuery warehouse (prod-data-warehouse / report skills). Draft responses land as `Drafted` for review.
3. **Collaborate in the working sheet, not the markdown.** `python3 scripts/make_working_sheet.py` (Claude runs it after processing) regenerates `WORKING - Diligence Responses.xlsx`: every open item with the current draft in an editable Response column (yellow), a Verdict dropdown (Approved / Claude: revise (see notes) / Discuss), and a Notes-to-Claude column. Answer some questions yourself right in the Response cells, hand others to Claude via notes ("pull this from BQ", "draft this, here's the gist"). Closed items sit on a reference tab.
4. **Say "sync the working sheet."** Claude reads your edits back into `TRACKER.md` — your text verbatim (your voice wins), verdicts flip statuses (Approved), notes get acted on — then regenerates a fresh working sheet and commits. The stale sheet is dead after every sync: always edit the latest.
5. **Say "prep the response"** once items are Approved: the export script produces the dated outbound xlsx (Approved rows export as Closed; internal notes and `[Steve: …]` placeholders never leave), email-only attachments are staged, and after you confirm the send, statuses flip and SHARED-LOG gets its rows.

## Stable anchors

- Question IDs (`1.1`, `4.2`, …) are never renumbered; new questions in an existing topic area take the next number in that section.
- Statuses: `Open` (we owe) · `Drafted` (written, unreviewed) · `Partial` (sent, more owed) · `Closed`.
- Every artifact that leaves the building = one SHARED-LOG row per channel, same day.

## Who owes what (keep current)

- **FPF (Raymond):** indicative terms or a pass — still outstanding as of 2026-10-18. On the 2026-10-14 Accial call Steve referred to "another fund" taking Zed to its IC on Monday 2026-10-19; presumed FPF [Steve: confirm].
- **Accial (Carrie / Lawrence / Mikko / Marco):** a proposed facility structure (SPV vs direct loan secured on receivables at $5M, US SPV feasibility) and feedback / an IOI, targeting before year-end. Manila in-person 2026-10-16 went well (Jon + Auvrey); Marco nudging internally, his lens is unit economics / annualized yield.
- **Zed → Accial:** (a) interchange fee data for their profitability model (tracker 14, **Drafted** — `Prior Responses (outside data room)/Interchange by Month_20261026_DRAFT.xlsx`; Steve to decide $-vs-% and window, then send); (b) the breakeven-scale answer promised in Manila (tracker 15, Drafted — ~30K active users on Steve's quick math; model figure pending projections update).
- **Zed → data room (pending Steve):** review `Data Room/Product/How Zed Works_20261007.pdf` (draft, built 2026-10-07 from sent responses 6.1/7 et al.), then upload to Box / Product and tell Claude so the SHARED-LOG row is added.
- **Zed:** no diligence owed to FPF as of 2026-09-18 (all 28 responses delivered; funds-flow diagram live in Box / Product; 9/18 call raised no new questions). Steve to catch up with Raymond the week of 9/28 after FPF's internal meeting. Accial pipeline now in deep diligence (CRM: `Analyses (internal)/Debt Fundraising CRM.xlsx`).
- **Potential next step (parked per Steve 2026-09-18 — do not execute until asked):** updated unit-economics pro forma at a 50% revolving share. The version FPF holds (`Zed Unit Economics_vF.xlsx`, emailed 8/5) assumes 30% revolving, while the target stated on the 9/18 call was a 50/50 revolver/transactor mix; FPF may ask for it if they model off the call.

## Sensitivity

Personal private repo (`STAbraham/debt_dd`) — deliberately not the org. Pre-decisional negotiation content; keep it that way until the facility is signed.

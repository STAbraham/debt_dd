# Zed debt DD — working conventions

Workspace for responding to debt-facility due diligence from credit funds. The `debt-dd` skill (in `~/.claude/skills/debt-dd/`) operates this repo; this README is the contract a fresh session works from.

## Layout

- **`TRACKER.md`** — source of truth for every diligence question: ID, status, question, response. Outbound spreadsheets are *generated* from it (`python3 scripts/export_responses.py [YYYYMMDD]`); `**Note (internal):**` and `**Delivered:**` lines never leave the file.
- **`SHARED-LOG.md`** — provenance ledger: every artifact the fund has received, when, and via which channel. Updated on every share, no exceptions.
- **`METHODS.md`** — internal-only record of how each produced data artifact/analysis was built (sources, queries, filters, caveats, review status), written the same turn the work is done. BigQuery is the source of truth for data questions; risky assumptions get raised to Steve as `[Steve: …]` placeholders instead of being resolved unilaterally.
- **`Data Room/`** — mirror of the actual Box data room (Financials, Loan Tape, Payment Data, Q1 Board Deck, …). Keep in lockstep with Box: anything uploaded there gets copied here (and vice versa) plus a SHARED-LOG row.
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

## Sensitivity

Personal private repo (`STAbraham/debt_dd`) — deliberately not the org. Pre-decisional negotiation content; keep it that way until the facility is signed.

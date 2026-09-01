# Zed debt DD — working conventions

Workspace for responding to debt-facility due diligence from credit funds. The `debt-dd` skill (in `~/.claude/skills/debt-dd/`) operates this repo; this README is the contract a fresh session works from.

## Layout

- **`TRACKER.md`** — source of truth for every diligence question: ID, status, question, response. Outbound spreadsheets are *generated* from it (`python3 scripts/export_responses.py [YYYYMMDD]`); `**Note (internal):**` and `**Delivered:**` lines never leave the file.
- **`SHARED-LOG.md`** — provenance ledger: every artifact the fund has received, when, and via which channel. Updated on every share, no exceptions.
- **`Data Room/`** — mirror of the actual Box data room (Financials, Loan Tape, Payment Data, Q1 Board Deck, …). Keep in lockstep with Box: anything uploaded there gets copied here (and vice versa) plus a SHARED-LOG row.
- **`Prior Responses (outside data room)/`** — artifacts shared via email only (non-standard requests we deliberately keep out of the data room).
- **`Diligence Question Responses/`** — archive of outbound response spreadsheets actually sent, dated.
- **`inbox/`** → **`inbox/processed/`** — raw inputs land in the former, move to the latter once propagated.

## How a diligence turn works

1. **Drop raw inputs in `inbox/`** — fund emails with new questions, call notes, raw data pulls, anything. No formatting needed.
2. **Say "process the inbox."** New questions get inventoried into `TRACKER.md` with stable IDs (next number in the matching section, or a new section). Each gets a response channel: tracker text, data-room pointer ("See X in Data Room / Y"), new data-room upload, or email attachment for non-standard asks. Data pulls needed to answer can come from the BigQuery warehouse (prod-data-warehouse / report skills). Draft responses land as `Drafted` for review.
3. **Review by diff** — every turn is a commit; `git log` / the TRACKER changelog tell the story. Approve or edit drafts by ID ("1.6 is fine, soften 4.2").
4. **Say "prep the response"** when ready to send: the export script produces the dated xlsx, email-only attachments are staged, and once sent, statuses flip to Closed/Partial and SHARED-LOG gets its rows.

## Stable anchors

- Question IDs (`1.1`, `4.2`, …) are never renumbered; new questions in an existing topic area take the next number in that section.
- Statuses: `Open` (we owe) · `Drafted` (written, unreviewed) · `Partial` (sent, more owed) · `Closed`.
- Every artifact that leaves the building = one SHARED-LOG row per channel, same day.

## Sensitivity

Personal private repo (`STAbraham/debt_dd`) — deliberately not the org. Pre-decisional negotiation content; keep it that way until the facility is signed.

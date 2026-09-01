# Zed debt DD — working conventions

Docs for Zed's debt-facility due diligence. Living docs (diligence tracker, lender Q&A, data-room notes, term-sheet analyses) live at the top level and will be added as the process kicks off; each carries a version, changelog, and stable IDs.

## How iteration works

1. **Drop raw inputs in `inbox/`** — email PDFs, call notes, screenshots, pasted threads, DD questionnaires, anything. No formatting needed; a `.md` with three bullets from a call is fine. Name with a date if convenient (`YYYY-MM-DD-<source>.md`).
2. **Tell Claude "process the inbox"** (any session). Claude reads each item, updates the docs, appends a changelog entry, moves the item to `inbox/processed/`, and commits.
3. **Review by diff, not by re-reading.** Every doc change is a git commit. Ask "what changed since I last read?" or use `git log --oneline` / `git diff <sha>` — the changelog at the top of each doc tells the same story in prose.

## Stable anchors (the interface for feedback)

- **Decisions:** D-numbers in the main doc. To revisit one, reference it by ID ("lender says no — reopen D3").
- **Requirements / diligence items:** R-numbers (and other lettered series) in the docs.
- **Open questions:** numbered; partner/lender answers slot in by number ("they answered #2: …").
- Docs carry per-section status tags: `VERIFIED` (checked against code/data/authoritative docs), `ASSUMED` (safe default, proceeding), `PENDING <owner>` (blocked on an external answer).
- IDs are never renumbered — retired items get strikethrough so old references stay valid.

## Current external dependencies (who owes what)

- *(none yet — add one line per open external thread as they arise: who owes what, and what it gates.)*

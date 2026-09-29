# Upload strategy — getting long documents into Google Drive without burning tokens

Written 2026-09-28 after publishing five revisions of the facility-structure doc through the Google Drive MCP connector.

## What went wrong with the current method

- The Drive connector's `create_file` takes the document **inline** in the tool call. The structure doc is ~80 KB of HTML, so every publish meant pasting ~20K tokens into one call, after re-reading the file from disk (another 15–20K) to get it byte-exact. Five publishes (v1, v2, v3, v3 re-spaced, v4) ≈ 150–200K tokens spent moving the same bytes back and forth.
- The connector **cannot update a Google Doc's content in place** — `update_file` changes only title and folder. Every revision is therefore a new doc with a new URL, and the previous one is renamed "[SUPERSEDED]". Hence the clutter in the "Zed Debt DD" Drive folder.
- Google's HTML importer drops paragraph spacing, which forced an extra "spacing pass" republish.

## Would a local .docx help?

Only if the transport changes too:

- A `.docx` pushed through the **same connector** would be *worse* on tokens: it takes `base64Content`, which inflates size by a third, and zipped bytes tokenise badly. HTML text is the cheapest thing to push through the connector.
- The real fix is **uploading from disk**, so the content never enters the model's context. Then the model edits the local source with small targeted replacements (a few hundred tokens per revision — already how the HTML source is maintained) and a script or sync client moves the file.
- Once uploading from disk, `.docx` *is* the better source format: Google's docx importer preserves headings, tables and paragraph spacing more faithfully than its HTML importer. Generate it with python-docx from the same structure.

## Option A — Google Drive for Desktop (no API, no token) — recommended

The pattern already used elsewhere on this machine for a shared workbook: keep the file in a folder that Drive for Desktop syncs, and "publishing" is just overwriting the file on disk.

- Location: `~/Library/CloudStorage/GoogleDrive-steve@zedcard.co/My Drive/Zed Debt DD/` (create the folder in Drive; Drive for Desktop mirrors it).
- Source of truth stays in the repo (`Analyses (internal)/…docx`); a one-line copy publishes it. The Drive link is stable across revisions.
- It opens in Google Docs' **Office-compatibility mode** — readable, commentable, editable, but a `.docx` underneath rather than a native Google Doc. Rendering of headings/tables/spacing is faithful.
- **Merge rule:** if Steve edits in Docs, Drive writes the changes back into the same `.docx`. Before any overwrite, pull the Drive copy and diff it against the repo copy at paragraph/table level (python-docx exposes the tree; coarser than spreadsheet cells but workable). Remote edits win or are merged first — never blind-overwrite. Same discipline as the working-sheet guard in `scripts/make_working_sheet.py`.
- Prerequisite to confirm: Drive for Desktop is running for the zedcard.co account on this Mac (the CloudStorage path above exists, which suggests yes).

## Option B — native Google Doc via the Drive REST API (needs a credential)

Only if a *native* Google Doc (not compat mode) is required.

- Small `scripts/publish_doc.py`: `files.update` with media upload replaces the doc's content **in place** (stable URL, no superseded copies); `files.export` pulls it back as docx for diffing.
- Auth: an OAuth **desktop-client** flow (one-time browser consent, refresh token stored outside the repo, e.g. `~/.zed-drive-token`) — not a service account, since the docs must be owned by steve@zedcard.co. Nothing of this sort exists on the machine today; the connector's auth is not reachable from scripts.
- Merge is harder than Option A: Google rewrites the document on import, so a re-export is never byte-comparable to the source. Conventions that work: Steve comments rather than edits; or export-and-diff before every overwrite and show what would be lost.

## Decision

Not set up yet. If v5+ of the structure doc (or any other long Drive document) becomes necessary, use **Option A**. Setup is under an hour and pays back on the second revision. If v4 turns out to be near-final once FPF's terms land, the current method is tolerable and no setup is warranted.

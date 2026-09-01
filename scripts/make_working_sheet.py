#!/usr/bin/env python3
"""Generate the staging spreadsheet Steve edits: WORKING - Diligence Responses.xlsx.

Usage: python3 scripts/make_working_sheet.py

"Working" tab = every non-Closed item, with editable Response / Verdict /
"Notes to Claude" columns (yellow). "Closed (reference)" tab = what's already
been sent. Regenerated from TRACKER.md after every sync — don't hoard edits
in an old copy; edit, then tell Claude to "sync the working sheet".
"""
from pathlib import Path

from openpyxl import Workbook
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.utils import get_column_letter
from openpyxl.worksheet.datavalidation import DataValidation

from export_responses import parse

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "WORKING - Diligence Responses.xlsx"

EDIT_FILL = PatternFill("solid", fgColor="FFF7DE")
HDR_FILL = PatternFill("solid", fgColor="1F2937")
HDR_FONT = Font(bold=True, color="FFFFFF")
WRAP = Alignment(wrap_text=True, vertical="top")


def style_sheet(ws, widths, editable_cols=()):
    for i, w in enumerate(widths, 1):
        ws.column_dimensions[get_column_letter(i)].width = w
    for c in ws[1]:
        c.fill, c.font = HDR_FILL, HDR_FONT
    for row in ws.iter_rows(min_row=2):
        for c in row:
            c.alignment = WRAP
            if c.column in editable_cols and ws.title == "Working":
                c.fill = EDIT_FILL
    ws.freeze_panes = "A2"


def main():
    items = parse((ROOT / "TRACKER.md").read_text())
    open_items = [it for it in items if it["status"] != "Closed"]
    closed = [it for it in items if it["status"] == "Closed"]

    wb = Workbook()
    ws = wb.active
    ws.title = "Working"
    ws.append(["ID", "Topic", "Status", "Question", "Response (edit me — your text wins)",
               "Verdict", "Notes to Claude", "Claude's internal context (won't be sent)"])
    for it in open_items:
        ws.append([it["id"], it["topic"], it["status"], it["q"], it["a"], "", "", it["note"]])
    dv = DataValidation(type="list", formula1='"Approved,Claude: revise (see notes),Discuss"',
                        allow_blank=True, showDropDown=False)
    ws.add_data_validation(dv)
    dv.add(f"F2:F{max(len(open_items) + 1, 2)}")
    style_sheet(ws, [7, 26, 10, 45, 70, 24, 40, 45], editable_cols=(5, 6, 7))

    ref = wb.create_sheet("Closed (reference)")
    ref.append(["ID", "Topic", "Question", "Response as sent", "Delivered"])
    for it in closed:
        ref.append([it["id"], it["topic"], it["q"], it["a"], it["delivered"]])
    style_sheet(ref, [7, 26, 45, 70, 30])

    wb.save(OUT)
    print(f"Wrote {OUT.name}: {len(open_items)} working items, {len(closed)} closed for reference")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Export TRACKER.md to a dated outbound response spreadsheet.

Usage: python3 scripts/export_responses.py [YYYYMMDD]
Writes "Diligence Question Responses/Diligence Responses_<date>.xlsx".

Internal-only lines (**Note (internal):** ... and **Delivered:** ...) are
stripped; everything else in the A: block is exported verbatim. Items still
marked Drafted trigger a warning — review them before sending.
"""
import re
import sys
from datetime import date
from pathlib import Path

from openpyxl import Workbook
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

ROOT = Path(__file__).resolve().parent.parent
SECTION_RE = re.compile(r"^## (\d+)\. (.+)$")
ITEM_RE = re.compile(r"^### (\S+) (.+) \[(\w+)\]$")
INTERNAL_FIELDS = ("**Note (internal):**", "**Delivered:**")


def parse(md: str):
    items, section = [], ""
    cur, field = None, None
    for line in md.splitlines():
        m = SECTION_RE.match(line)
        if m:
            section = m.group(2).strip()
            continue
        m = ITEM_RE.match(line)
        if m:
            cur = {"id": m.group(1), "topic": m.group(2).strip(), "status": m.group(3),
                   "section": section, "q": [], "a": []}
            items.append(cur)
            field = None
            continue
        if cur is None:
            continue
        if line.startswith("**Q:**"):
            field = "q"
            cur["q"].append(line[len("**Q:**"):].strip())
        elif line.startswith("**A:**"):
            field = "a"
            cur["a"].append(line[len("**A:**"):].strip())
        elif line.startswith("**Note (internal):**"):
            field = "note"
            cur.setdefault("note", []).append(line[len("**Note (internal):**"):].strip())
        elif line.startswith("**Delivered:**"):
            field = "delivered"
            cur.setdefault("delivered", []).append(line[len("**Delivered:**"):].strip())
        elif field:
            cur.setdefault(field, []).append(line)
    for it in items:
        for k in ("q", "a", "note", "delivered"):
            it[k] = "\n".join(it.get(k, [])).strip().replace("\\*", "*")
    return items


def main():
    stamp = sys.argv[1] if len(sys.argv) > 1 else date.today().strftime("%Y%m%d")
    items = parse((ROOT / "TRACKER.md").read_text())
    if not items:
        sys.exit("No items parsed from TRACKER.md — check heading format '### <id> <topic> [<Status>]'.")
    drafted = [it["id"] for it in items if it["status"] == "Drafted"]
    if drafted:
        print(f"WARNING: still Drafted, not Approved (review before sending): {', '.join(drafted)}")
    # fund-facing status: an Approved item is being answered by this very sheet
    for it in items:
        if it["status"] == "Approved":
            it["status"] = "Closed"

    # one tab per request batch: the initial doc (sections 1-5), then each follow-up email
    initial = [it for it in items if not it["section"].startswith("Follow-up")]
    followup = [it for it in items if it["section"].startswith("Follow-up")]

    # styling copied from the 8/5 sheet the fund already holds
    NAVY, HDR_BLUE = "FF17365D", "FF5B9BD5"
    SECT_FILL, RESP_FILL = "FFDDEBF7", "FFFFF2CC"
    STATUS_FILLS = {"Closed": "FFFCE4D6", "Partial": "FFFCE4D6"}
    THIN, MEDIUM = Side(style="thin"), Side(style="medium")

    def write_tab(wb, title, banner, tab_items, group_of, section_label, first=False):
        ws = wb.active if first else wb.create_sheet()
        ws.title = title
        ws.append([banner])
        ws.merge_cells("A1:F1")
        ws["A1"].font = Font(name="Calibri", bold=True, size=18, color="FFFFFFFF")
        ws["A1"].fill = PatternFill("solid", fgColor=NAVY)
        ws["A1"].alignment = Alignment(horizontal="left", vertical="center")
        ws.row_dimensions[1].height = 30
        ws.append([])
        headers = ["ID", "Section", "Topic", "Diligence question / request", "Status", "Response / evidence"]
        ws.append(headers)
        for c in ws[3]:
            c.font = Font(name="Calibri", bold=True, size=11, color="FFFFFFFF")
            c.fill = PatternFill("solid", fgColor=HDR_BLUE)
            c.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
            c.border = Border(bottom=THIN)
        ws.row_dimensions[3].height = 24

        top_wrap = Alignment(vertical="top", wrap_text=True)
        prev_group = None
        for it in tab_items:
            new_group = group_of(it) != prev_group
            prev_group = group_of(it)
            r = ws.max_row + 1
            vals = [it["id"], section_label(it), it["topic"], it["q"], it["status"], it["a"]]
            fonts = [Font(name="Calibri", size=10, bold=True, color="FF666666"),
                     Font(name="Calibri", size=10, bold=True, color=NAVY),
                     Font(name="Calibri", size=10, bold=True, color="FF000000"),
                     Font(name="Calibri", size=10, color="FF0000FF"),
                     Font(name="Calibri", size=10, color="FF000000"),
                     Font(name="Calibri", size=10, color="FF000000")]
            fills = ["FFFFFFFF", SECT_FILL, "FFFFFFFF", "FFFFFFFF",
                     STATUS_FILLS.get(it["status"], "FFEDEDED"), RESP_FILL]
            aligns = [Alignment(horizontal="center", vertical="top"), top_wrap, top_wrap, top_wrap,
                      Alignment(horizontal="center", vertical="center", wrap_text=True), top_wrap]
            for ci, (v, fo, fi, al) in enumerate(zip(vals, fonts, fills, aligns), 1):
                cell = ws.cell(row=r, column=ci, value=v)
                cell.font, cell.alignment = fo, al
                cell.fill = PatternFill("solid", fgColor=fi)
                cell.border = Border(top=MEDIUM if new_group else None, bottom=THIN)

        widths = [8, 30, 32, 78, 15, 38]
        for i, w in enumerate(widths, 1):
            ws.column_dimensions[get_column_letter(i)].width = w
        ws.freeze_panes = "A4"

    wb = Workbook()
    write_tab(wb, "Initial Questions", "Diligence Questions",
              initial, group_of=lambda it: it["section"], section_label=lambda it: it["section"],
              first=True)
    write_tab(wb, "Follow-up Questions 8.26", "Follow-up Questions (email 8/26/2026)",
              followup, group_of=lambda it: it["id"].split(".")[0],
              section_label=lambda it: f"Email question {int(it['id'].split('.')[0]) - 5}")

    out = ROOT / "Diligence Question Responses" / f"Diligence Responses_{stamp}.xlsx"
    wb.save(out)
    print(f"Wrote {out.relative_to(ROOT)} ({len(initial)} initial + {len(followup)} follow-up items)")


if __name__ == "__main__":
    main()

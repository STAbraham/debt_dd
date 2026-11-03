#!/usr/bin/env python3
"""One-slide pptx: first-payment defaults by origination vintage, three bins, in the Q3 board deck's chart style.
Geometry/fonts lifted from the deck's 'Revolving, Transacting & Installment Balances' slide (16:9, 13.33 x 7.5 in;
title Atlas Grotesk Medium 36pt at 0.54/0.29 in; chart frame from 1.21 in; note box Atlas Grotesk Regular at the foot).
Colours: deck chart palette 4472C4 / 7030A0 / ED7D31 / A5A5A5; totals as an invisible line series labelled above the bars."""
import csv, json, copy, sys
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.chart.data import CategoryChartData
from pptx.enum.chart import XL_CHART_TYPE, XL_LEGEND_POSITION, XL_LABEL_POSITION
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN
from lxml import etree

INP, OUT = sys.argv[1], sys.argv[2]
inp = json.load(open(INP)); rows = inp["fpd"]["rows"]; notes = inp["fpd"]["notes"]
cats = [f"{['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][int(r['month'][5:7])]} {r['month'][2:4]}" for r in rows]
BLUE, PURPLE, ORANGE, GREY, DARK = "4472C4", "7030A0", "ED7D31", "A5A5A5", "404040"
SERIES = [("Fraud ring", "ring", PURPLE), ("Other fraud signals", "fraud", ORANGE), ("Other FPD", "credit", BLUE)]
FONT = "Atlas Grotesk Regular"

prs = Presentation(); prs.slide_width = Inches(13.333); prs.slide_height = Inches(7.5)
s = prs.slides.add_slide(prs.slide_layouts[6])

def text(x, y, w, h, t, size, font=FONT, bold=False, color=DARK, align=PP_ALIGN.LEFT):
    tb = s.shapes.add_textbox(Inches(x), Inches(y), Inches(w), Inches(h)); tf = tb.text_frame; tf.word_wrap = True
    tf.margin_left = tf.margin_right = Inches(0.05); tf.margin_top = tf.margin_bottom = Inches(0.02)
    first = True
    for para in (t if isinstance(t, list) else [t]):
        p = tf.paragraphs[0] if first else tf.add_paragraph(); first = False
        r = p.add_run(); r.text = para; r.font.size = Pt(size); r.font.name = font; r.font.bold = bold; r.font.color.rgb = RGBColor.from_string(color); p.alignment = align
    return tb

text(0.54, 0.29, 12.48, 0.88, "First-Payment Defaults by Origination Vintage", 36, font="Atlas Grotesk Medium", color="000000")

def chart(x, y, w, h, title, key, scale, fmt, total_fmt):
    cd = CategoryChartData(); cd.categories = cats
    for name, k, _ in SERIES: cd.add_series(name, [r[key(k)] / scale for r in rows])
    cd.add_series("Total", [sum(r[key(k)] for _, k, _ in SERIES) / scale for r in rows])
    gf = s.shapes.add_chart(XL_CHART_TYPE.COLUMN_STACKED, Inches(x), Inches(y), Inches(w), Inches(h), cd); ch = gf.chart
    ch.has_title = True; ch.chart_title.text_frame.text = title
    tp = ch.chart_title.text_frame.paragraphs[0]; tp.runs[0].font.size = Pt(11); tp.runs[0].font.name = FONT; tp.runs[0].font.bold = False; tp.runs[0].font.color.rgb = RGBColor.from_string(DARK)
    ch.has_legend = True; ch.legend.position = XL_LEGEND_POSITION.TOP; ch.legend.include_in_layout = False; ch.legend.font.size = Pt(9); ch.legend.font.name = FONT
    ch.font.name = FONT; ch.font.size = Pt(9); ch.font.color.rgb = RGBColor.from_string(DARK)
    plot = ch.plots[0]; plot.gap_width = 60; plot.overlap = 100
    for ser, (_, _, col) in zip(plot.series, SERIES):
        ser.format.fill.solid(); ser.format.fill.fore_color.rgb = RGBColor.from_string(col)
        ser.data_labels.show_value = True; ser.data_labels.number_format = fmt; ser.data_labels.number_format_is_linked = False
        ser.data_labels.font.size = Pt(8); ser.data_labels.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF); ser.data_labels.position = XL_LABEL_POSITION.CENTER
    va = ch.value_axis; va.has_major_gridlines = True; va.major_gridlines.format.line.color.rgb = RGBColor.from_string("D9D9D9"); va.format.line.fill.background()
    va.tick_labels.number_format = total_fmt; va.tick_labels.number_format_is_linked = False; va.tick_labels.font.size = Pt(9)
    ca = ch.category_axis; ca.tick_labels.font.size = Pt(9); ca.format.line.color.rgb = RGBColor.from_string("D9D9D9")
    # --- move the 4th series into a lineChart with no line and labels above (the deck's "Total" trick) ---
    ns = {"c": "http://schemas.openxmlformats.org/drawingml/2006/chart", "a": "http://schemas.openxmlformats.org/drawingml/2006/main"}
    cs = ch._chartSpace; bar = cs.find(".//c:barChart", ns); sers = bar.findall("c:ser", ns); tot = sers[-1]; bar.remove(tot)
    # hide zero data labels on stacked segments: leave as-is (zeros print "0"); instead delete labels of zero points
    for ser in sers:
        vals = [float(v.text) for v in ser.findall(".//c:val//c:v", ns)]
        dl = ser.find("c:dLbls", ns)
        for i, v in enumerate(vals):
            if v == 0 and dl is not None:
                d = etree.SubElement(dl, "{%s}dLbl" % ns["c"]); dl.insert(0, d)
                etree.SubElement(d, "{%s}idx" % ns["c"]).set("val", str(i)); etree.SubElement(d, "{%s}delete" % ns["c"]).set("val", "1")
    line = etree.SubElement(bar.getparent(), "{%s}lineChart" % ns["c"]); bar.addnext(line)
    etree.SubElement(line, "{%s}grouping" % ns["c"]).set("val", "standard"); etree.SubElement(line, "{%s}varyColors" % ns["c"]).set("val", "0")
    line.append(tot)
    for e in tot.findall("c:spPr", ns) + tot.findall("c:dLbls", ns) + tot.findall("c:invertIfNegative", ns): tot.remove(e)
    spPr = etree.SubElement(tot, "{%s}spPr" % ns["c"]); ln = etree.SubElement(spPr, "{%s}ln" % ns["a"]); etree.SubElement(ln, "{%s}noFill" % ns["a"])
    tot.find("c:cat", ns).addprevious(spPr)
    mk = etree.SubElement(tot, "{%s}marker" % ns["c"]); etree.SubElement(mk, "{%s}symbol" % ns["c"]).set("val", "none"); spPr.addnext(mk)
    dl = etree.SubElement(tot, "{%s}dLbls" % ns["c"]); mk.addnext(dl)
    nf = etree.SubElement(dl, "{%s}numFmt" % ns["c"]); nf.set("formatCode", total_fmt); nf.set("sourceLinked", "0")
    txPr = etree.SubElement(dl, "{%s}txPr" % ns["c"]); bp = etree.SubElement(txPr, "{%s}bodyPr" % ns["a"]); etree.SubElement(txPr, "{%s}lstStyle" % ns["a"])
    p = etree.SubElement(txPr, "{%s}p" % ns["a"]); ppr = etree.SubElement(p, "{%s}pPr" % ns["a"]); dr = etree.SubElement(ppr, "{%s}defRPr" % ns["a"]); dr.set("sz", "800"); dr.set("b", "0")
    sf = etree.SubElement(dr, "{%s}solidFill" % ns["a"]); etree.SubElement(sf, "{%s}srgbClr" % ns["a"]).set("val", DARK)
    etree.SubElement(dr, "{%s}latin" % ns["a"]).set("typeface", FONT); etree.SubElement(p, "{%s}endParaRPr" % ns["a"]).set("lang", "en-US")
    etree.SubElement(dl, "{%s}dLblPos" % ns["c"]).set("val", "t")
    for tag, v in (("showLegendKey", "0"), ("showVal", "1"), ("showCatName", "0"), ("showSerName", "0"), ("showPercent", "0"), ("showBubbleSize", "0")): etree.SubElement(dl, "{%s}%s" % (ns["c"], tag)).set("val", v)
    etree.SubElement(line, "{%s}marker" % ns["c"]).set("val", "1")
    for ax in bar.findall("c:axId", ns): etree.SubElement(line, "{%s}axId" % ns["c"]).set("val", ax.get("val"))
    # legend: drop the "Total" entry
    leg = cs.find(".//c:legend", ns); le = etree.SubElement(leg, "{%s}legendEntry" % ns["c"]); leg.find("c:legendPos", ns).addnext(le)
    etree.SubElement(le, "{%s}idx" % ns["c"]).set("val", "3"); etree.SubElement(le, "{%s}delete" % ns["c"]).set("val", "1")
    return gf

chart(0.42, 1.15, 7.0, 4.45, "FPD principal more than 15 days past due, by origination month (₱ thousands)", lambda k: k, 1000, '#,##0', '#,##0')
chart(7.55, 1.15, 5.4, 4.45, "FPD accounts, by origination month", lambda k: "n_" + k, 1, '0', '0')

# note block: the tab's footnote, condensed to fit (bins 1–3, controls, basis, counts), 7.5pt
blk = [n for n in notes if not n.startswith("How to read")]
order = [2, 3, 4, 5, 1, 6]  # ring, signals, other, caught, basis, counts  (indices into notes)
lines = [notes[i].replace("• ", "") for i in order]
text(0.54, 5.62, 12.38, 1.85, lines, 7.5, color="000000")
prs.save(OUT); print("saved", OUT)

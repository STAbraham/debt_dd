# Methods — internal record of how data artifacts and analyses were produced

**Internal only, never shared.** One entry per produced artifact or load-bearing analysis: sources (tables/files/queries), filters, as-of date, caveats, and who reviewed it. Written the same turn the work is done. SHARED-LOG rows for produced artifacts should point at their entry here.

---

## 2026-09-01 — Installment fee schedule verification (analysis; backs 8/26 items 4, 1, 7)

**Question:** Confirm the origination-fee formula and add-on rate the fund asked about (their 8/26 items 4 and 7).
**Source:** `Data Room/Loan Tape/Installment Tape_20260814.xlsx`, sheet `Installment-Tape` (the artifact the fund holds — emailed 2026-08-21). Deduped to 4,974 unique plans by `Original Transaction Id`, taking each plan's first row (the one carrying Tenure and Upfront Fee rate).
**Method:** For each plan, computed `Interest for each month / Principal Amount` and read the upfront-fee rate column against Tenure.
**Findings:**
- Upfront fee rate is exactly 0.5% × term months for **all** plans: 1.5% ('3 mo.', n=2,117), 3% ('6 mo.', n=1,630), 6% ('12 mo.', n=1,227).
- Monthly add-on interest is exactly 1.0% of original principal for 4,897 plans; **77 plans show 0%** — unexplained (promo?), flagged to Steve in 8/26 item 4's internal note.
**Caveats:** Verified against the shared extract, not the warehouse; the peso upfront-fee amount sits in a second, unlabeled duplicate column (e.g. ‑82.35 = 5,490 × 1.5%) charged in plan month 1.
**Reviewed by:** pending Steve.

## 2026-09-02 — Installment Funds Flow diagram (produced artifact; answers the flow-of-funds half of 8/26 items 1–2)

**Artifact:** `Data Room/Product/Installment Funds Flow_20260902.pdf` (2 pages: swimlane diagram + cash summary). Source of truth for regeneration: HTML in the session scratchpad (`funds-flow-item1-print.html`), rendered via headless Chrome print-to-PDF.
**Content basis:** Steve's walkthroughs in this session and the working sheet — post-purchase Pay-Over-Time-style enrollment, four-party purchase flow (swipe at merchant → auth via Mastercard → Zed approves → T+1 settlement), MPD includes the full installment billing, revolving-interest accrual on billed installments for revolvers. Steve's explicit confirmations: first 1/X bills on the enrollment-cycle statement alongside the upfront fee; monthly billing = 1/X principal + 1% add-on; Zed is a single issuing entity funding settlement from its own balance sheet (no bank funding partner); acquirer collapsed into the Mastercard rail; early termination footnote only.
**Numbers:** worked example ₱12,000 × 6 months — fee/interest rates from the 2026-09-01 installment-tape verification (entry above): 3% upfront (₱360), 1%/mo add-on (₱120), totals ₱2,480 first statement, 5 × ₱2,120, ₱13,080 collected (9.0% finance charge). Revolving 3%/mo and DPD-1 freeze per 1.2/1.4 as sent.
**Caveats:** T+1 settlement timing and "net of MDR / net of interchange" framing are Steve's description, not independently verified. Not yet uploaded to Box — SHARED-LOG row pending Steve's confirmation.
**Reviewed by:** Steve (iterated live in this session; content approved before PDF render).

## 2026-09-03 — Interchange data does NOT exist in the warehouse (negative finding; scopes item 11)

**Question:** Can item 11 (net interchange % of GMV) be answered from BigQuery? Steve suspected not.
**Method:** Scanned `epicac-2.epicac_prod_direct.INFORMATION_SCHEMA.COLUMNS` across all 62 tables for `%interchange%`, `%mdr%`, and settlement/revenue/fee/network table names; inspected fee/amount/settlement columns on `public_transactions` and `public_network_messages`.
**Finding:** No interchange, MDR, or settlement-fee field anywhere. Transaction tables carry only gross amounts (`amount`, `amount_requested`). Consistent with the warehouse being a CDC mirror of the app Postgres DB — interchange is earned on the network/settlement side and never posts to cardholder accounts. Only fee-adjacent tables: `public_late_payment_fees`, `public_network_messages` (auth messages, no economics).
**Implication:** Item 11's numerator must come from i2c/Mastercard settlement reporting or finance records; BQ can only supply the GMV denominator once the base is defined.
**Reviewed by:** pending Steve.

## 2026-09-11 — i2c network transaction counts by month (produced artifact)

**Artifact:** `Analyses (internal)/i2c Network Transactions by Month_20260911.xlsx` — monthly table + line chart of PIN POS & ATM (MCREE00007G) + Signature (MCREE00007A) transaction counts, per Steve's request.
**Source:** the 10 monthly i2c Processing Services invoices Sep 2025 – Jun 2026 (`inbox/processed/i2c invoices/`), text-extracted with pdftotext and parsed on the two billing codes; quantities and dollar amounts both captured, sum = count of the two lines.
**Figures (total counts):** Sep 80,260 · Oct 87,920 · Nov 103,412 · Dec 112,475 · Jan 93,874 · Feb 105,534 · Mar 150,821 · Apr 179,144 · May 201,921 · Jun 221,364. PIN POS & ATM is negligible throughout (3–22/month); the series is effectively Signature volume.
**Caveats:** counts are i2c-billed network transactions (auth-level billing units), not settled purchase counts — don't equate to GMV transaction counts without checking i2c's billing definition. Not shared with the fund; internal only unless Steve routes it.
**Reviewed by:** pending Steve.

## 2026-09-11 — Debt Fundraising CRM (produced artifact)

**Artifact:** `Analyses (internal)/Debt Fundraising CRM.xlsx` — Pipeline tab (stage-gated, equity-style; dropdown stages 0–8 + Passed/Dormant), Correspondence Log, Stage Definitions.
**Source:** Apple Mail local store for steve@zedcard.co (Envelope Index sqlite for thread discovery + .emlx bodies), read with Steve's permission. Swept sender domains on debt keywords and "Zed & X"-pattern intro subjects since mid-2025.
**In pipeline (per Steve 2026-09-11: Harrison intros only):** FPF (deep diligence) and Accial Capital (first call 8/10; NDA + term parameters exchanged Aug 11–19 — bodies recovered 2026-09-11 after Steve downloaded the thread). Advisor: Tomorrow Capital (Harrison Emmett-Lee — source of both intros). Removed per Steve: LenderLink (credit underwriting service, not a lender — Ces's workstream) and Arc/joinarc (spammy cold outreach).
**Excluded as out of scope:** Wells Fargo 2023 (US corporate banking, dormant), BRK Capital (equity), UnionBank (ops banking), Zaidwood + financing-solution.com (broker spam), LenderLink (credit underwriting service), Arc/joinarc (spam), "Additional Capital Issuance" thread (equity legal).
**Caveats (resolved):** the three Aug 2026 Accial messages were initially server-side only; Steve opened the thread in Mail 2026-09-11 and the bodies were recovered — [confirm] placeholders cleared. Send date/state of FPF verified from Steve's own 9/11 email.
**Reviewed by:** pending Steve.

## Open verification (started, not finished)

- ~~8/26 item 3 (now item 8) — statement tape "Installment Fees" definition~~ **Closed 2026-09-09 without a trace:** Steve answered authoritatively in the working sheet — the field contains upfront fees + termination fees (final-cycle interest classified as a fee in the ledger); monthly add-on interest is not included.

## 2026-09-28 — Facility structure overview (internal working note)

**Artifact:** Google Doc "Zed — Debt Facility Structure: How to Think About It (internal, 2026-09-28)" — https://docs.google.com/document/d/1B2POnzz-62F4MagVNHtErlwWT4Muzwc3a-ahGoZhVxM/edit (Drive folder "Zed Debt DD": https://drive.google.com/drive/folders/1bi1pgN-jiHkGKYQQbT2GqoacR2nphoVX) ; source HTML archived at `Analyses (internal)/Facility Structure - How to Think About It_20260928.html`.
**Source:** Consolidation of three chat sessions (9/18–9/28) on borrower choice (ZFPI / Delaware parent / new SG SPV), the recourse ladder (true sale → direct ZFPI security → assigned secured intercompany → share pledge), asset-backed vs venture debt, tax map, on/off-balance-sheet and guarantee. Inputs: Raymond's diligence pattern + 8/12 and 9/18 calls; Carrie (Accial) 8/19 structuring email; Steve's entity facts (US parent, no SG entity yet). General knowledge, not legal/tax advice — every rate and rule is marked [verify] for counsel.
**Not a fund-facing artifact.** Nothing here has been shared.
**Reviewed by:** pending Steve.

## 2026-09-28 — Facility structure overview v2 (verified) + comparables

**Artifact:** Google Doc "Zed — Debt Facility Structure: How to Think About It (v2, verified, 2026-09-28)" — https://docs.google.com/document/d/1dlhpwNIAdiYqCUI6xu85zE-UmUaf63arpzZXDvzWe5o/edit in Drive folder "Zed Debt DD". v1 renamed "[SUPERSEDED by v2]" in the same folder. Source HTML: `Analyses (internal)/Facility Structure - How to Think About It_v2_20260928.html`.
**Method:** Three parallel research passes against primary sources (IRC/CFR via Cornell LII, IRS, State Dept; NIRC/RAs via lawphil & Official Gazette, BIR, BSP FX Manual + FAQ, SEC PH, PPSR/LRA; Singapore ITA/Companies Act/IRDA via SSO, IRAS treaty texts, ACRA, MAS; IFRS/PwC Viewpoint) plus a comparables sweep of PH consumer-lending fintech debt deals (press releases, DealStreetAsia, Salmon bond T&Cs). Raw vetting notes for US and PH in `Analyses (internal)/verification-notes/`; Singapore + comparables findings are embedded in doc §§2, 3, 6.1, 8, 9.
**Corrections vs v1:** PH–US interest = Art. 12; DST 0.75% of issue price (CMEPA 2025); PPSR live since 3 Feb 2025; BSP endorsement required for a ZFPI securitisation; card cap = Circular 1165 (3%/mo); SG→Panama WHT 5% by treaty; ASPV exemption inapplicable; SG SPV taxed 17% on spread (no §13(8) shelter); SG running cost S$4–6K/yr; §163(j) $31M/$32M; IRDA §64/§440 nuances; parent's charge over SG SPV shares is a UCC matter.
**Key new conclusion:** every debt route bears ≥15% PH withholding (money must enter ZFPI as a loan); Delaware ≈15%, Singapore ≈20% + tax on spread, direct ≈20%. Market-standard PH offshore structure = secured loan to SG/HK/ADGM holdco with PPSA receivables security + share pledges + pledged intragroup loans (rung 3); no PH true-sale SPV ever disclosed; 2025–26 shift to onshore PHP bank lines on PPSR-registered receivables pledges.
**Still open [counsel]:** BSP encumbrance limits for a non-bank card issuer; VAT/GRT on receivable sales; foreign-SPV "doing business"; offshore remittance of peso collections when SG SPV is borrower; FPF vehicle's Panama tax residency; PPT risk.
**Not fund-facing.** Nothing shared. **Reviewed by:** pending Steve.

## 2026-09-28 — Facility structure v3: first-facility framing, stage norms, US SPV, tax bases

**Artifact:** Google Doc "Zed — Debt Facility Structure: How to Think About It (v3, 2026-09-28)" — https://docs.google.com/document/d/1mT3i7W82xwPKG9C6quAW2m9i8oTBthV8yEZNIXnV71U/edit (Drive folder "Zed Debt DD"; re-published 2026-09-28 with paragraph spacing per Steve — same content; v1, v2 and the pre-spacing v3 copy renamed "[SUPERSEDED]" in place). Source HTML: `Analyses (internal)/Facility Structure - How to Think About It_v3_20260928.html`.
**Added per Steve:** (1) framing as Zed's first structured credit facility — size/scale vs complexity; (2) §3 "what is common at our stage" from two research passes: EM lender published terms (Accial, Lendable, CIM, Helicap, Cauris/ALMA), World Bank/CGAP 2025 focus note, FMO/Dalberg 2026 landscape study, US warehouse primers (a16z, Mayer Brown, DLA Piper 2025), disclosed regional first facilities; (3) Delaware LLC SPV as fourth borrower option, vetted against IRS/Delaware Code/UCC/case law (`verification-notes/2026-09-28-us-spv-vetting.md`); (4) §7.0 explicit tax bases (gross interest coupon / net spread / principal / net income) with a $5M, 15%-coupon worked example per route.
**Key conclusions:** SPV isolation is available at $5M but is the lender's tool and comes with recourse to the originator in EM practice; no SPV-based $3–15M first facility publicly disclosed; expect a parent guarantee — negotiate cap (US reference 10% of commitment) and step-down, refuse opco share pledge; US LLC SPV ≈ parent tax profile (0% US WHT + 15% PH WHT ≈ 2.3 pts of principal/yr) vs Singapore ≈ 3.1 pts; gating open item: BIR treaty relief for a US disregarded LLC (Form 6166 issues in owner's name) — fallback is parent-direct on the PH leg.
**Corrections vs v2:** Delaware LLC annual tax $400 (HB 400, 2026); tax bases made explicit throughout; guarantee norms split US-warehouse vs EM reality.
**Not fund-facing.** Nothing shared. **Reviewed by:** pending Steve.

## 2026-09-28 — Facility structure v4: OpCo/HoldCo/SPV context + BSP permissibility of receivables sale

**Artifact:** Google Doc "Zed — Debt Facility Structure: How to Think About It (v4, 2026-09-28)" — https://docs.google.com/document/d/1pulsLbR_ftjFd17K2s26-C7tMv4sS19-PjEqIof0nG0/edit (Drive folder "Zed Debt DD"; v3 renamed "[SUPERSEDED by v4]"). Source HTML: `Analyses (internal)/Facility Structure - How to Think About It_v4_20260928.html`.
**Added per Steve:** (1) §2 OpCo / HoldCo / SPV explainer (ZFPI = OpCo; Zed Financial, Inc. = HoldCo; SPV = sister shell; intermediate HoldCo noted and not pursued); (2) §3.1 names the borrowing entity for each comparable first facility (BillEase = PH OpCo FDFC; Salmon = ADGM HoldCo; ErudiFi = SG-HQ HoldCo; Uploan = SG HoldCo Uploan Asia Pte Ltd) and states none used an SPV — replaces v3's unexplained "secured opco or holdco loans"; §9 legend and labels updated; (3) §5.1 on whether the BSP permits ZFPI to sell receivables to a Singapore or US SPV, from a primary-text research pass (`verification-notes/2026-09-28-bsp-receivables-sale-vetting.md`).
**Key conclusion (§5.1):** no BSP prohibition or prior approval on a non-bank card issuer selling or pledging receivables (RA 10870, Circular 1003, MORNBFI CC-Regs); RA 9267 is optional for a private bilateral sale; the obstacles are FX repatriation (FX Manual has no slot for sale of domestic receivables to non-residents), DST/VAT leakage outside RA 9267, and "doing business" exposure for a revolving foreign purchaser. Action regardless of route: amend cardholder T&Cs for disclosure consent to assignees/financiers (RA 10870 §16(a)) + consumer-neutral assignment clause (Circular 1160). Open items (i)–(l) added to §10; item (a) largely resolved.
**Not fund-facing.** Nothing shared. **Reviewed by:** pending Steve.

## 2026-09-28 — Facility structure v5: Salmon correction, cumulative rungs, first-loss vs guarantee, Uploan unpacked

**Artifact:** Google Doc "Zed — Debt Facility Structure: How to Think About It (v5, 2026-09-28)" — https://docs.google.com/document/d/19p_jJEix9bXl_oaQiekObRhJKIqdOdkG0CmhU51LxUA/edit (Drive folder "Zed Debt DD"; v4 renamed "[SUPERSEDED by v5]"). Source HTML: `Analyses (internal)/Facility Structure - How to Think About It_v5_20260928.html`.
**Correction (Steve caught it):** v3/v4 cited Salmon's bond package as "i.e. rung 3" while §3.2 called its share pledges a holdco/venture-debt feature. Re-read from the disclosed terms: share pledges (rung 4) + OpCo guarantees + pledged intragroup loans with no disclosed receivables lien = rung 4 plus unsecured OpCo claims — a HoldCo bond, not asset-backed. §5 now says so explicitly, adds that rungs are combined in real deals, and places OpCo guarantees / unsecured intragroup pledges between rungs 3 and 4. §3.1 and §9 updated to match.
**Elaborations added (from chat, non-redundant):** §2 "Senior" definition; §2 "First loss vs guarantee" (structural vs contractual, loss-sequence, repurchase-obligation trap); §8 links guarantee shape to first-loss sizing; §3.1 Uploan bullet unpacked (HoldCo borrower, on-balance-sheet meaning, senior secured, PPSA-compliant under interim perfection pre-PPSR, security package inferred not disclosed).
**Not fund-facing.** Nothing shared. **Reviewed by:** pending Steve.

## 2026-09-28 — Facility structure v6: collateral vs plumbing, §4.2 configurations, recommended first-facility shape

**Artifact:** Google Doc "Zed — Debt Facility Structure: How to Think About It (v6, 2026-09-28)" — https://docs.google.com/document/d/1fPtjZop6uEDJGJRKiyXwnyXII7XGvDv34kRSSp1LQtY/edit (Drive folder "Zed Debt DD"; v5 renamed "[SUPERSEDED by v6]"). Source HTML: `Analyses (internal)/Facility Structure - How to Think About It_v6_20260928.html`.
**Per Steve:** earlier versions conflated ZFPI's receivables (the collateral — OpCo asset, PPSR-registered lien, ownership and day-to-day control stay with ZFPI) with the parent's intercompany loan (the plumbing — parent asset carrying funds in / debt service out / tax legs). v6: §2 adds a short PPSA-lien explainer; §4 Delaware row reworded; new §4.2 table walks three configurations end to end (money in, debt service out, what secures, recourse beyond collateral, tax, entities, fit at $5M) and names the recommended first-facility shape — parent borrows, ZFPI grants the fund a direct PPSR lien + collection-account control (rung 2) with a collateral-limited ZFPI guarantee, intercompany note assigned as belt-and-braces (rung 3), no ZFPI share pledge, no SPV; §5 rung 3 rewritten as a two-step (ZFPI secures the note on receivables, parent assigns it) with the note as conduit, not collateral; Uploan bullet cut to ~40% of v5 length; §11 posture item 3 points to configuration A.
**Not fund-facing.** Nothing shared. **Reviewed by:** pending Steve.

## 2026-10-07 — "How Zed Works — product and revenue model" (produced artifact, DRAFT for Steve's review)

**Artifact:** `Data Room/Product/How Zed Works_20261007.pdf` (4 pages). Source HTML: `Analyses (internal)/How Zed Works_20261007_source.html`, rendered via headless Chrome print-to-PDF (same pipeline as the funds-flow diagram). **Not yet uploaded to Box; no SHARED-LOG row until Steve confirms.**
**Purpose (per Steve):** a generic "how does Zed work and how does it make money" document for the data room, consolidating the product-mechanics content of responses 6.1 and 7 (plus 1.2, 1.4, 2.1–2.2, 6.2, 8, 9.1–9.3, 10, 11, 12.1) without the FPF-specific framing — the charge-card/pay-in-full-as-separate-product premise correction is dropped as no longer relevant.
**Sources:** TRACKER.md answers as sent 8/5 and 9/11 only; every rate, formula and figure is lifted verbatim or arithmetically from them (3%/mo = 0.1%/day; MPD formula from 1.2; upfront 0.5%×months and 1%/mo add-on from 9.1; termination/first-cycle unwind from 2.1/9.3; "installment fees" field definition from 8; fees charged from 10; net interchange 1.43%/1.17%/1.84% from 11; BSP ceilings + CCAP from 12.1; DPD-1 freeze, ₱1,000 late penalty after 2-day grace, Net Flow Rate / 8 DPD buckets from 1.4 and 7; no restructuring from 13.3). Worked examples: ₱12,000/6-mo (matches the funds-flow PDF) and the ₱1,000/₱250-on-day-11 interest example from 7.
**Deliberately excluded:** call-only figures (33%/7%/10% mix, unit-economics $ figures), the charge-card transition narrative, anything not in a sent response.
**Reviewed by:** pending Steve.
**Revision 2026-10-07 (per Steve):** removed all performance-derived figures — the net-interchange averages (1.43% / 1.17% / 1.84%, item 11) in the card and the summary table are replaced with "per the Mastercard interchange schedule"; contractual rates and fees (3%/mo, 1%/mo add-on, 0.5%×months upfront, ₱1,000 late penalty, ₱1,000 MPD floor) retained. Lede now "Zed offers one product" and the balance-sheet/funding-partner clause is dropped as TMI; the standalone Funding card and the balance-sheet mention in §1 removed for the same reason. Footer no longer cites item 11 or "supersedes".
**Revision 2 (2026-10-07, per Steve):** ledger note on termination-fee classification removed (TMI). Installment step 1 now states that only eligible purchases can be enrolled; the eligibility criteria are not in any sent response, so the PDF carries a `[Steve: …]` placeholder that must be filled before upload. Summary-table termination-fee cell simplified.

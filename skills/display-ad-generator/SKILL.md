---
name: display-ad-generator
description: Generate display ad mock-ups for car finance campaigns using the PCP canvas rendering pipeline. Produces multi-size PNG ads with configurable headline, small print, background image, logo, colours, and tint overlay.
version: "1.0"
updated: 2026-04-01
category: creative
---

# Display Ad Generator — PCP Pipeline Protocol

## Purpose
Generate UK-compliant display ad creatives for finance campaigns (e.g. car.financecheque.uk) matching the exact rendering pipeline of the PCP webapp (scottishbay/static/pcp/pages/index.html).

## Source Pipeline (Reverse-Engineered from PCP)
The rendering pipeline from index.html renderAd() function (line ~3166):

1. **Solid colour fill** — ctx.fillRect with bg.color
2. **Background image cover-fit** — drawImageCover (scale to cover, centre crop)
3. **Tint overlay** — rgba(tintColour, tintOpacity) fillRect
4. **Logo** — top-left, ~22% of smaller dimension, transparent PNG
5. **Headline** — fitTextToBox, Arial Black Bold, centred or left-aligned depending on orientation
6. **Small print** — bottom zone (15% height), darkened background, white text, auto-shrink font
7. **Accent bar** — 3px neon accent line at bottom (only if no small print)

## Interactive Page Requirements
When serving the interactive ad generator page:
- **Ads MUST be pre-generated and visible on page load** — do NOT require the user to click Generate first
- All controls must be available for editing and regeneration (colours, background, logo, headlines, small print)
- Each ad card has DL (download PNG) and FS (fullscreen preview) buttons
- Default small print is the Jigsaw Claims compliance text (see Mandate section below)
- Assets (background, logo) must be embedded as base64 data URIs so the page is standalone
- Serve via `python3 -m http.server 8185 --bind 0.0.0.0` from `/home/unclehowell/scottishbay/static/pcp/`

## Key Metrics
- Safe padding: 10% of canvas (textSafePad)
- Small print zone: bottom 15% of height
- Logo zone: top 15% of height
- Headline zone: 35% of canvas height
- Font: Arial Black/Impact bold for headline, Arial regular for small print
- Small print layout: right-aligned, bottom-anchored

## Standard IAB Sizes
Leaderboard 728x90, Medium Rect 300x250, Half Banner 300x100,
Wide Skyscraper 160x600, Half Page 300x600, Mobile 320x50,
Billboard 970x250, Large Rect 336x280, Banner 468x60,
Square 1080x1080, Large Landscape 1200x600, Small Square 250x250

## PCP Default Colour Palette
#1a1a2e (dark blue), #16213e (navy), #0f3460 (royal blue),
#e94560 (red accent), #f5a623 (gold)

## FinanceCheque Mandate Small Print
PCP Refund is a trading name of Jigsaw Claims Ltd, authorised and regulated by the Financial Conduct Authority (FCA) for claims management activities (FRN: 912323). Registered Address: 66 Seymour Grove, Manchester, M16 0LN. Contact: info@jigsawclaims.co.uk. We will receive referral fees from third parties for successful claims at no cost to you. Using our service does not guarantee a faster or better outcome. You can also claim for free through your lender, the Financial Ombudsman Service, or the FCA compensation scheme launching in 2026

## Interactive Page
Located at: /home/unclehowell/scottishbay/static/pcp/pages/index_fc.html
Served via: python3 -m http.server 8185 --bind 0.0.0.0
Features: live canvas rendering, download PNG, fullscreen preview, background/logo upload, colour/tint controls, headline slots, small print textarea, auto-generate on page load.

## Assets
- Background image: /home/unclehowell/scottishbay/static/pcp/oak.png (embeddable)
- Logo: extracted from PCP defaults.json (transparent PNG)
- Both encoded as base64 and embedded in the interactive page

## Usage
1. Agent navigates to the page URL served from the local network
2. User reviews pre-generated ads on landing
3. User modifies controls (headline, colours, bg image, logo, small print)
4. User clicks Generate to re-render all combinations
5. User downloads individual PNGs or batch exports

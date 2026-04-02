# Display Ad Generator Skill

## Overview
The agent has reverse-engineered the PCP webapp ad generator (located at `/home/unclehowell/scottishbay/static/pcp/pages/`) and rebuilt it as a standalone, self-contained HTML page that generates UK-compliant display ad mock-ups matching the exact canvas rendering pipeline of the original webapp.

## Pipeline (from PCP index.html renderAd function)
1. **Solid colour fill** — ctx.fillRect with background colour
2. **Background image cover-fit** — scale to cover canvas, centre crop
3. **Tint overlay** — rgba(colour, opacity) fillRect over image
4. **Logo** — top-left, ~18% of smaller dimension, with safe-zone padding
5. **Headline** — fitTextToBox, Arial Black Bold, positioned below logo with clearance
6. **Small print** — bottom zone (16% height), darkened background, white text, auto-shrink font
7. Each canvas is a real PNG that can be downloaded or viewed fullscreen

## File Locations
- **Generator page:** `/home/unclehowell/scottishbay/static/pcp/pages/index_fc.html`
- **Default background:** `/home/unclehowell/scottishbay/static/pcp/pages/brand/bg.png`
- **Default logo:** `/home/unclehowell/scottishbay/static/pcp/pages/brand/logo.png`
- **Branding directory:** `/home/unclehowell/scottishbay/static/pcp/pages/brand/`

## Standard IAB Sizes Supported
Leaderboard 728x90, Medium Rect 300x250, Half Banner 300x100, Wide Skyscraper 160x600, Half Page 300x600, Mobile 320x50, Billboard 970x250, Large Rect 336x280, Small Square 250x250

## Page Features
- Ads auto-generate on page load (9 ads, one per size)
- Burger menu toggles settings sidebar (sizes, bg image, logo, colours, tint, headlines, small print)
- Download and fullscreen preview buttons per ad
- Export All PNG button
- Upload to change background/logo triggers regeneration
- Manual regenerate produces all combinations of selected sizes × headlines × colours

## How to Deploy
1. Replace `./brand/bg.png` and `./brand/logo.png` in the page directory
2. Update the JS defaults at the top of the script: SP (small print), SZ (sizes array), H (headlines), C (colours)
3. Serve via: `python3 -m http.server 8189 --bind 0.0.0.0` from the parent directory
4. Page URL: `http://{local-ip}:8189/pages/index_fc.html`

## Creating a New Campaign
To create a new campaign ad generator:
1. Set headline text (H array in JS)
2. Set small print (SP in JS)  
3. Set background colour defaults (C array in JS)
4. Set default images in `brand/` folder
5. Update page title and topbar heading
6. Regenerate and deploy on a new port

## Communication Rules
- NEVER send code to the user via Telegram without asking permission first
- Only send URLs (complete with http/https prefix and TLD)
- All output to user must be plain English, voice clips, or media attachments
- This rule is in `/home/unclehowell/brain/memory/communication-rules.md`

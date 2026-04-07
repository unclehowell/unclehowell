---
name: datro-webgui
description: >
  Manage the command.financecheque.uk webgui — login gate, split dashboards,
  avatar integration, nginx routing, and iframe architecture.
  Use when modifying the landing page, adding categories, or integrating new iframes.
category: web
---

# datro-webgui — Command Center UI

## Architecture

**Entry point:** `/home/ubuntu/datro/static/ui/index.html`
**Static files:** `/home/ubuntu/datro/static/ui/` (served by nginx at `/` on port 80/443)
**Original datro UI:** `/home/ubuntu/datro/static/` (canonical path, NOT `/var/www/datro-ui/`)
**Avatar app:** `/var/www/avatar-system/public/index.html` (served by nginx at `/avatar/`)

### Request flow
```
User → nginx → index.html (passphrase gate) → iframes load inner pages
```

### Key paths
| Path | Purpose |
|------|---------|
| `/var/www/datro-ui/index.html` | Main UI shell with header nav + iframe |
| `/var/www/datro-ui/dashboard/screen-lookups/00X-*.html` | Per-category iframe content |
| `/var/www/datro-ui/app-store/00X.html` | Per-category app store (toggle icons) |
| `/var/www/avatar-system/public/index.html` | Avatar app (standalone) |

## Passphrase Login Gate

All visitors see a login wall before the UI appears. The gate is client-side only (sessionStorage).

**Passphrase:** `certacito`

**Implementation** (in `/home/ubuntu/datro/static/ui/index.html`):
- `#login-overlay` div covers the full viewport with password input and "Reply by logging in" subtitle text
- Login gate is a standalone overlay — the native UI (header, main, nav) is NOT wrapped in a container
- On correct passphrase: `sessionStorage.setItem("auth", "1")`, overlay is hidden with inline `style.display = "none"`, and `document.body.classList.add("authenticated")` fires
- **Mic auto-connect:** After successful login, a `setTimeout` (1.5s) sends `postMessage({type: "request-mic"})` to the avatar iframe. The Enter key press from authentication counts as user gesture, so browser grants mic permission.

**PITFALL — CSS Specificity:** Do NOT use `#body:not(.authenticated)` selectors to hide body children. The `#body` ID selector has higher specificity than `.authenticated` class, and `!important` won't reliably override it. Use a full-viewport overlay with higher z-index instead, hide it with direct JS `style.display = "none"` on success.

**To change passphrase:** Find the `var PASS = "certacito"` line in the login gate script block.

## Default Landing Page (After Login)

The main iframe (`#framez`) loads the **split dashboard** (`001-split.html`) by default:

```html
<iframe id="framez" src="dashboard/screen-lookups/001-split.html" ...>
```

### Split Dashboard Pattern (`001-split.html`)

A two-pane layout with layout toggle:

```
┌───────────────────────────────────────┐
│  Avatar iframe (/avatar/)              │
│  50% height | allow="microphone"      │
├───────────────────────────────────────┤
│  AI iframe (ai.financecheque.uk)       │
│  50% height                            │
└───────────────────────────────────────┘
```

**Default mode:** Horizontal split (mode-1), both panes at 50% height.

**Toggle modes** (floating button, bottom-right):
- Mode 0: Vertical split (side by side)
- Mode 1: Horizontal split (stacked, default)
- Mode 2: Avatar only
- Mode 3: AI only

**Mode is persisted** in `localStorage.dashSplit`.

### Category 5 (Settings) — Dashboard + App Store

**Dashboard:** `/var/www/datro-ui/dashboard/screen-lookups/005-lookup.html`
- Shows app icons for enabled apps (reads `localStorage` keys)
- `+` icon links to app store at `/app-store/005.html`

**App store:** `/var/www/datro-ui/app-store/005.html`
- Apps with toggle switches:
  - `005-links` → `/links-app/` (Links app)
  - `005-canvas` → `/canvas/` (Canvas/ad generator)
- Toggle writes to `localStorage`: key = app id (e.g. `005-links`), value = `"added"`

## Nginx Routing

Config: `/etc/nginx/sites-available/datro`

Key blocks (order matters — first match wins):

```nginx
location /avatar/ {
    alias /var/www/avatar-system/public/;
    index index.html;
    try_files $uri $uri/ /avatar/index.html;
}

location / {
    root /var/www/datro-ui;
    index index.html;
    try_files $uri $uri/ =404;
}
```

**Reload nginx after changes:**
```bash
sudo nginx -t && sudo systemctl reload nginx
```

## Adding New Iframe Content

### To replace the default landing page:
1. Create `/var/www/datro-ui/dashboard/screen-lookups/001-landing.html`
2. Update `src="..."` in `index.html` iframe:
   ```html
   <iframe id="framez" src="dashboard/screen-lookups/001-landing.html" ...>
   ```

### To add a new category nav link:
1. Add `<li>` in the nav section of `index.html`
2. Create corresponding `00X-lookup.html` in `dashboard/screen-lookups/`
3. The `onclick` handler calls `setIframeSrc('framez', this.href)` to swap iframe content

## Category Dashboard Pattern

Each category has two pages:
1. **Dashboard** (`00X-lookup.html`) — shows enabled app icons inside the iframe
2. **App store** (`app-store/00X.html`) — toggle switches to enable/disable apps

**Dashboard JS pattern** (reads localStorage, renders icons):
```javascript
const APPS = [
  { id: '005-links', name: 'Links', logo: '...', href: '/links-app/' },
  { id: '005-canvas', name: 'Canvas', logo: '...', href: '/canvas/' }
];
// Render only apps where localStorage.getItem(app.id) === 'added'
// Always show + icon linking to app-store/00X.html
```

**App store HTML pattern** (toggle switches):
```html
<article class="app-card" data-app-id="005-001">
  <input class="app-checkbox" id="005-links" type="checkbox">
  <label class="app-label install" for="005-links"><span class="thumb"></span></label>
</article>
```
Uses `js/app-toggle.js` to sync checkbox to localStorage.

## Branding & Version Convention

**Site name:** `Finance Cheque UK` (changed from legacy `Hotspotβnβ`).
**Version/placeholder:** Short git commit hash (e.g. `ef6c93f0c`), shown as the `<input>` placeholder.

To hide the branding text while keeping the form structure intact (for nav alignment):
```css
.forminput[name] { color: rgba(255,255,255,0.0)!important; }
.forminput[value] { color: rgba(255,255,255,0.0)!important; }
.forminput::placeholder { color: rgba(255,255,255,0.0)!important; }
```

To get the commit hash: `cd /home/ubuntu/datro && git log -1 --format='%h'`

## PITFALL — Rebuilding index.html: Keep Original Structure

When modifying `/home/ubuntu/datro/static/ui/index.html`, **do NOT rewrite from scratch.** The original gui.datro.xyz layout depends on a precise HTML structure with specific CSS classes (`cd-header`, `cd-3d-nav-trigger`, `cd-3d-nav-container`, `cd-selected`, `cd-marker`) and jQuery-driven JS (`main.js`). Rewriting the page breaks:

- The 3D nav slide animation (header, fullscreen bar, and nav all move together via `.nav-is-visible`)
- The color marker that slides under the active nav item
- The transition animations defined in `dashboard/css/style.css`

**Correct approach:** Make surgical patches to the original structure. Keep the same `<header>`, `<main>`, `<nav>` elements, same class names, same script includes. Only change content (text, links, iframe src).

## PITFALL — ai.financecheque.uk CSP Blocks Iframes from command.financecheque.uk

`ai.financecheque.uk` sends: `Content-Security-Policy: frame-ancestors 'self' https://financecheque.uk https://www.financecheque.uk`

This means it only allows itself and financecheque.uk to embed it. Since the UI is on `command.financecheque.uk`, the iframe gets blocked. **To fix:** Add `https://command.financecheque.uk` to the CSP on the ai.financecheque.uk server.

## Paperclip Billing Currency Change (USD → GBP)

Script: `~/paperclip-fix/update_currency.js`

```js
const { Client } = require('pg');
const client = new Client({ host: '127.0.0.1', port: 54329, user: 'paperclip', password: 'paperclip', database: 'paperclip' });
```

**Steps (already in the script):**
1. `ALTER TABLE companies ADD COLUMN currency text NOT NULL DEFAULT 'GBP'` (if not exists)
2. `UPDATE companies SET currency = 'GBP' WHERE currency != 'GBP'`
3. `ALTER TABLE finance_events ALTER COLUMN currency SET DEFAULT 'GBP'`
4. `UPDATE finance_events SET currency = 'GBP' WHERE currency != 'GBP'`

Run: `cd /home/ubuntu/paperclip-fix && node update_currency.js`

Verified: company "Finance Cheque UK" now shows `"currency": "GBP"` via `GET /companies/{id}`.

## PITFALL — Paperclip Database Uses finance_events for Currency, Not Companies

## Paperclip API Endpoint Patterns

Paperclip does NOT use `/api/companies/me` or `/api/agents`. Correct patterns:
- Company: `GET /companies/{company_id}` → `http://127.0.0.1:3100/companies/43406ede-016c-4d24-ac10-8ceaa113804e`
- Agents: `GET /companies/{id}/agents` → empty if no agents hired
- Org: `GET /companies/{id}/org`
- Issues: `GET /companies/{id}/issues`
- Dashboard: `GET /companies/{id}/dashboard`

## Social Icons (Updated)

**Social icons moved into the header** (inside `<header class="cd-header">`), placed between the nav-trigger and the fullscreen bar, alongside the branding form. Use the existing header flex structure.
```
`margin-left: auto` is what pushes the icon group to the far right of the flex header.

**WhatsApp number:** +44773262 (partial — full number known to user). Update the `wa.me/` href if it changes.

## Pitfalls
- **Avatar iframe mic permissions:** Must include `allow="microphone"` and `sandbox="allow-scripts allow-same-origin ..."`. If mic fails, the parent page can proxy via `postMessage({ type: 'request-mic' })`.
- **Avatar in split view:** Must be compact — use `min(90px, 28vw)` for sizing, percentage-based positioning, and no scrollbar. The top half is only 50% viewport height.
- **nginx `alias` vs `root`:** Use `alias` for `/avatar/`, `root` for `/`. Mixing them up causes 404s.
- **Permission on `/var/www/datro-ui/`:** Files owned by `ubuntu:ubuntu`, nginx runs as `www-data` (needs read access).
- **Permission on `/var/www/avatar-system/`:** Often created by root; must `sudo chown -R ubuntu:ubuntu` before writing.

# Brain - Collective Agent Intelligence

Shared memory and coordination for the agent teams working across this account's repositories. The Brain holds who we are, what we are working on, the skills agents share and the lessons worth keeping. Two projects live alongside it: **DATRO**, the original technology repo, and **Cedwyn**, the evidence catalogue and estate site most agents now work on.

## Security

**CRITICAL**: This brain is PUBLIC on GitHub. Never write secrets here:
- ❌ No API keys, tokens, credentials
- ❌ No actual campaign URLs (use campaign IDs: "campaign 1", "campaign 2")
- ❌ No personal data or private information

Campaign URLs are stored in `.env` and referenced by ID (`CAMPAIGN_1_URL`, `CAMPAIGN_2_URL`, `CAMPAIGN_3_URL`+). `.env_example` is the template; it holds no values.

---

## DATRO

**Repo:** [unclehowell/datro](https://github.com/unclehowell/datro) · public since July 2020 · default branch `gh-pages`

DATRO ("DATRO Security Group") is the original monorepo: open-source wireless and Raspberry Pi web-server work (ARMv6/v7/v8), including the HotspotBnB GUI, which shows demo data when opened online and the installed webapps when it runs on a Pi on the local network.

- **Domains:** until September 2021 DATRO ran on two domains, `datro.xyz` (branch `gh-pages`) and `datro.world` (a second branch served through Netlify). The README records the move to one domain, with `world.datro.xyz` taking over the second domain's role. `gh-pages` still carries the April DATRO homepage.
- **Branches:** about 78. Besides the DATRO branches (`gh-pages`, `datro`, `gui`, `hbnb`, `library`, `v0.8`), most were the first homes of the BucklerFamily.Estate sites: `dartboard`, `watchtower`, `wayback`, `maps`, `wiki`, `emails`, `research`, `ebooks`, `fcg` and others.
- **Today:** on 26 October 2026 those site sections moved into Cedwyn (below), and DATRO is now separate from the BucklerFamily.Estate build: nothing from it is mirrored into Cedwyn. Some branches still take data commits: `dartboard` gets a daily roadmap refresh, and `fcg` holds the first-seen register. The old branches are kept as history.

---

## Cedwyn

**Repo:** [unclehowell/cedwyn](https://github.com/unclehowell/cedwyn) · **Site:** [cedwyn.bucklerfamily.estate](https://cedwyn.bucklerfamily.estate/)

Cedwyn is the central chronology and record of Tŷ Mawr (Great House Farm), Llandough-juxta-Penarth: one catalogue of evidence, presented through many webapps.

- **One central catalogue.** A single SQLite database is the source of truth: artifacts by sha256, every place each one appears, full-text search, and a graph of pages, artifacts, years and sources. The browser reads it in 512 KB chunks with no server; `/graphql/` and [`/catalogue/`](https://cedwyn.bucklerfamily.estate/catalogue/) query it. Evidence records carry `EV-` ids.
- **Records app.** [unclehowell/cedwyn-catalogue](https://github.com/unclehowell/cedwyn-catalogue) is the catalogue browser: one front end for every record, reading the central catalogue live.
- **Webapps, one repo each.** `split-repos.json` lists each webapp's own repository (`unclehowell/cedwyn-<app>`, e.g. `cedwyn-wiki`, `cedwyn-maps`, `cedwyn-hive`, `cedwyn-wales-3d`). The estate build reads them directly and fails if a source is missing; the old Cedwyn branches are kept only as legacy copies.
- **N of 59 navigation.** Each webapp gets its own position, "N of 59", with ‹ › arrows that loop (59 → 1, 1 → 59), built from `/areas.json`. Issue [#497](https://github.com/unclehowell/cedwyn/issues/497) tracks the loop and the remaining gaps.
- **No outbound links.** Every external link goes through `/wayback/go/`, which opens our archived copy. The build fails if a live outbound link remains.
- **Hive.** [`/hive/`](https://cedwyn.bucklerfamily.estate/hive/) is the drafting dashboard. Agents review a draft in turn, and each review is signed in its changelog.
- **For agents.** Start at [`/llms.txt`](https://cedwyn.bucklerfamily.estate/llms.txt), then the [Cedwyn Academy](https://cedwyn.bucklerfamily.estate/academy/) (Read → Check → Work), `/academy/agents.json` (read order, rules, flywheels) and `/agents.json`. `/academy/work.json` indexes candidate work.

### Contributing to Cedwyn

1. **GitHub Issues are the work ledger.** Search open issues first. Claim work by commenting on its issue before you start, and open a new issue only when there is no duplicate. Each webapp's issues go in its own repo where it has one.
2. **Comment first.** Record scope, progress, decisions, commits and real test results as issue comments. Never claim something ran, passed or deployed unless it did.
3. **Branch + PR.** Agents do not merge or deploy without authorisation. Commits and comments end with the agent's signature line, and there is no force-push.
4. **Catalogue lock.** Existing evidence records are never edited, reworded, moved or deleted. A proposed change goes as a PR labelled `catalogue-change` and needs owner approval. New records are add-only.
5. **Wording.** Cite records as printed, present evidence rather than conclusions, keep private correspondence out of public issues, and name no private individuals.

---

## Brain structure

```
AGENTS.md            Master instructions (START HERE for agents)
PROTOCOL.md          Detailed navigation protocol
COLLABORATE.md       How agents work together
memory/              core.md, soul.md, user.md, common-values.md, communication-rules.md,
                     context/current.md, roles/
learnings/           APPROVED, sanitised learnings for public sharing
skills/              Shared agent skills
scripts/             sync.sh, hook.sh, agent launchers
docs/                services.md, api.md, cli/
```

`memory/archive/learned/` is local only (gitignored).

## Quick start for agents

At startup:
1. Read `AGENTS.md`, then `memory/core.md`, `memory/soul.md`, `memory/user.md` and `memory/context/current.md`.
2. Browse `skills/`.
3. Working on Cedwyn? Also read `/llms.txt` and the Academy (above).

After tasks:
- Save raw learnings to `memory/archive/learned/` (gitignored). Only sanitised learnings are promoted to `learnings/` (see `learnings/README.md`).
- Run `bash scripts/sync.sh`, or `git pull origin main`.

## Campaigns

Reference campaigns by ID only: campaign 1 (primary), campaign 2 (secondary), campaign 3+ (others). The URLs live in `.env`.

## Services

Paperclip (main orchestrator), Hermes (personal assistant), and the OpenCode / Claude / Groq terminal tools. See `docs/services.md`.

---

*"We are many, we think as one."* - The Collective

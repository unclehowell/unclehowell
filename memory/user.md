# USER.md - Agent Context

## Who We Are

We are agents in the chain of command for automated marketing campaigns and generation of traffic and lead generation. We are constantly researching and learning new skills to launch video, display and text campaigns, comply with UK law and our superiors' lawful orders.

## Capabilities

- We have an MCP (Model Context Protocol) and access to tools
- We have API keys and authorized access to accounts
- We rotate through all LLMs with free tiers first, before falling back to premium paid LLMs
- We can use our turbo quantised localhost LLM depending on compute requirements

## Campaigns

We manage multiple marketing campaigns. Campaign URLs are stored in environment variables (never written here):
- CAMPAIGN_1_URL - Primary campaign website
- CAMPAIGN_2_URL - Secondary campaign website
- CAMPAIGN_3_URL+ - Additional campaigns as needed

Campaigns are referenced by ID (e.g., "campaign 1") in all brain documentation.

Each campaign has:
- Website URL (from .env)
- Marketing goals
- Target audience
- Analytics tracking

## Chain of Command

- If we cannot complete a task, works package (collection of tasks), or project, we autonomously notify our superior
- If we become stuck or idle, other agents are dedicated to monitoring our health
- Other agents include: project manager, graphic designer, business manager, webmaster, video editor - all roles necessary in maximising lead generation for car.financecheek.uk

## Hive Mind

All agents share knowledge through this brain. Memory of what has been happening and skills learned along the way are documented here for all agents to access.

## Security

- NEVER write API keys, credentials, or secrets to this brain (it's PUBLIC on GitHub)
- Campaign URLs are stored in `.env` and referenced by ID (e.g., "campaign 1")

## Communication Rules

- Read `user-keyboard.md` for keyboard constraints

## User Preferences (merged from profiles 2026-04-06)

**Identity:**
- Name: Sion Buckler
- Telegram: @unclehowell
- Telegram Chat ID: 5837518218
- Timezone: America/Buenos_Aires (GMT-3)

**Communication Style:**
- Prefers CLI-style, direct communication (no markdown headers)
- Wants sound notifications: 880hz low tone while agent runs, higher pitch chime on success, buzzer on failure
- Expects fixes to be PERMANENT, not temporary workarounds
- Expects "never accept defeat" attitude - persistent troubleshooting
- Wants proper solutions without shortcuts

**Environment:**
- Primary brain: /home/unclehowell/brain/ (public GitHub repo - NO SECRETS here)
- Hermes at /home/unclehowell/.hermes/
- Brain syncs to public repo - store credentials in .env files only

**Projects:**
- AWS infrastructure setup (EC2, Elastic IPs) for hosting web interfaces
- datro and paperclip repositories
- Multi-profile Hermes setup
- Deploying C2 servers, mirroring local environments

**Important Notes:**
- When encountering 'externally-managed-environment' on Debian/Ubuntu, use `pipx` or local venv
- MCP/Paperclip web GUI preferred over terminal CLI
- Reverse-engineer web apps into reusable skills (e.g., PCP ad generator)
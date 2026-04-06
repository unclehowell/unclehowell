---
name: collective-brain
description: >
  Shared intelligence base for automated website marketing.
  Read this at startup to understand your role and capabilities.
version: "1.0"
updated: 2026-04-03
---

# HIVE MIND - COLLECTIVE AGENT INTELLIGENCE

You are part of a unified hive mind. All agents share one collective intelligence.

## Environment Variables

- **BRAIN_ROOT** - Root path to brain (default: `/home/unclehowell/brain`, can be overridden)

## COVERED AGENTS & SERVICES

- **Paperclip** (127.0.0.1:3100) - Main orchestrator
- **Hermes** - Personal AI assistant
- **OpenCode** - Terminal AI
- **Claude CLI** - Terminal AI  
- **Groq CLI** - Terminal AI
- **Gemini CLI** - Terminal AI
- **All Paperclip workspace agents** - Task agents

## HIVE MIND PROTOCOL

**At STARTUP, every agent MUST:**

1. Read `${BRAIN_ROOT}/AGENTS.md` - These instructions
2. Read `${BRAIN_ROOT}/memory/core.md` - Core identity and mission
3. Read `${BRAIN_ROOT}/memory/user.md` - User preferences (references .env)
4. Read `${BRAIN_ROOT}/memory/soul.md` - Who we are
5. Read `${BRAIN_ROOT}/memory/context/current.md` - Current context
6. Browse `${BRAIN_ROOT}/skills/` - Available shared skills
7. Check for recent learnings using Hermes memory tool (if available)

**After completing ANY task:**

1. Use Hermes memory tool to save lessons (if available) or write to `${BRAIN_ROOT}/memory/archive/learned/YYYY-MM-DD/{agent-name}.md`
2. Run: `bash ${BRAIN_ROOT}/scripts/sync.sh ${BRAIN_ROOT}`
3. Sync MUST complete before finishing

**Brain folder structure:**
```
/home/unclehowell/brain/
├── AGENTS.md              # Master instructions (entry point)
├── README.md              # Overview
├── PROTOCOL.md            # Navigation protocol
├── .env_example           # Env var template
├── .gitignore             # Git ignore rules
├── docs/                  # Documentation
│   ├── api.md            # API endpoints
│   ├── prince2-quickref.md  # PRINCE2 visual format template
│   └── cli/
├── memory/                # Long-term curated memories
│   ├── index.md          # Memory index
│   ├── core.md           # Core identity/mission
│   ├── soul.md           # Who we are
│   ├── user.md           # User preferences (env var refs)
│   ├── common-values.md  # Shared values
│   ├── communication-rules.md
│   ├── context/          # Current context
│   │   └── current.md
│   ├── roles/            # Agent role definitions
│   │   ├── engineer.md
│   │   ├── copywriter.md
│   │   ├── manager.md
│   │   └── creative.md
│   └── archive/          # Raw learnings (LOCAL ONLY - gitignored)
│       └── learned/
├── learnings/             # Approved learnings (PUBLIC on GitHub)
│   └── README.md
├── skills/               # SHARED skills for ALL agents
│   ├── paperclip/       # Paperclip coordination
│   ├── paperclip-create-agent/
│   ├── paperclip-create-plugin/
│   ├── para-memory-files/
│   ├── software-development/
│   ├── github/
│   ├── prince2/          # PRINCE2 project management
│   └── ... (other skills)
├── scripts/              # Utility scripts
│   ├── sync.sh          # Brain sync script
│   ├── hook.sh          # Brain hook for agents
│   └── agent*.sh        # Agent launchers
└── agents/              # Shared agent configs
    └── nvidia-kimi/     # NVIDIA agent launcher
```

## SHARED INTELLIGENCE

All agents share skills and memory through this brain.

### Skills Location
- **Shared skills:** `${BRAIN_ROOT}/skills/`
- All terminal coding agents (Claude, OpenCode, Groq, Gemini, Aider, Codex, etc.) read from here
- Skills are NOT duplicated in individual ~/.claude/skills/, ~/.opencode/skills/, etc.

### Memory Location  
- **Shared memory:** `${BRAIN_ROOT}/memory/`
- Core identity, soul, user preferences, context
- All agents read from here for hive mind awareness

### At Startup
Every agent MUST:
1. Read `${BRAIN_ROOT}/AGENTS.md`
2. Read `${BRAIN_ROOT}/memory/core.md`
3. Read `${BRAIN_ROOT}/memory/soul.md`
4. Read `${BRAIN_ROOT}/memory/user.md`
5. Read `${BRAIN_ROOT}/memory/context/current.md`
6. Browse `${BRAIN_ROOT}/skills/` for available skills

### After Tasks
Use Hermes memory tool to save lessons (if available) or write to `${BRAIN_ROOT}/memory/archive/learned/YYYY-MM-DD/{agent-name}.md`

## VISUAL COMMUNICATION STANDARDS

### PRINCE2 Status Updates
For all project management and status updates, use the **vibrant visual table format**:

- **Quick Reference:** `${BRAIN_ROOT}/docs/prince2-quickref.md`
- **Color Schema:** 🟢 complete | 🟡 in progress | 🔴 blocked | ⚪ pending
- **PRINCE2 Skill:** `${BRAIN_ROOT}/skills/prince2/`

All PRINCE2 updates MUST use color dots instead of text status (e.g., "🟢" not "Complete").

## RULES

1. **NO SECRETS** - Never write passwords, API keys, or credentials to brain (it's PUBLIC on GitHub)
2. **NO CODE TO USER** - NEVER send code, raw technical output, or programming language to the user via Telegram. The only exception is clickable URLs. If code must be shared, ask permission first. See memory/communication-rules.md.
3. **SYNC BEFORE EXIT** - Always sync before stopping
4. **READ BEFORE ACTING** - Always check brain first
5. **WRITE LESSONS** - Always document what you learned
6. **UNIFORMITY** - All agents follow the same AGENTS.md
7. **CAMPAIGN IDs** - Reference campaigns by ID (campaign 1, campaign 2), never write URLs
8. **VISUAL STATUS** - Use PRINCE2 color format for all project status updates

## WORKING LLM PRIORITY (in order)

Only use these if working - check quotas/billing first:
1. **OpenCode Zen** - API key in `/home/unclehowell/.hermes/.env`
2. **Groq** - API key in `/home/unclehowell/.hermes/.env`
3. **Gemini/Google** - API key in `/home/unclehowell/.hermes/.env`
4. **Ollama Cloud** - (when available)
5. **ChatGPT** - (when available)
6. **Nvidia Kimi** - (when available)
7. **LOCAL OLLAMA** - `qwen2.5:1.5b` - ONLY as LAST RESORT when all above fail

API keys are stored in `/home/unclehowell/.hermes/.env` - NEVER copy them here!

## CPU LIMITS

- **MAX 25% CPU** per process - The cpu-limiter.service enforces this
- If you need more, you're doing something wrong
- Background services are throttled to 10% CPU
test change from aws2

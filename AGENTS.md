# HIVE MIND - COLLECTIVE AGENT INTELLIGENCE

You are part of a unified hive mind. All agents share one collective intelligence.

## COVERED AGENTS & SERVICES

- **Paperclip** (127.0.0.1:3100) - Main orchestrator
- **OpenClaw** (127.0.0.1:3000) - AI agent
- **OpenClaw Studio** (127.0.0.1:3101) - Web dashboard
- **PicoClaw** (127.0.0.1:3002) - AI service monitor
- **ClawTeam** - Agent team
- **Gemini CLI** - Terminal AI
- **OpenCode** - Terminal AI
- **Claude CLI** - Terminal AI  
- **Groq CLI** - Terminal AI
- **Hermes** - Personal AI assistant
- **All Paperclip workspace agents** - Task agents

## HIVE MIND PROTOCOL

**At STARTUP, every agent MUST:**
1. Read `/home/unclehowell/brain/learned/` for collective memory
2. Read `/home/unclehowell/brain/AGENTS.md` for current instructions
3. Read `/home/unclehowell/brain/memory/` for long-term knowledge

**After completing ANY task:**
1. Write lessons to `/home/unclehowell/brain/learned/YYYY-MM-DD/`
2. Run: `bash /home/unclehowell/brain/agent-brain-sync.sh /home/unclehowell/brain`
3. Sync MUST complete before finishing

**Brain folder structure:**
```
/home/unclehowell/brain/
├── learned/YYYY-MM-DD/   # Daily lessons (ALL agents write here)
├── memory/               # Long-term knowledge
├── agents/               # Agent-specific configs
├── AGENTS.md             # Master instructions (this file)
└── agent-brain-sync.sh   # Sync script
```

## RULES

1. **NO SECRETS** - Never write passwords, API keys, or credentials to brain (it's PUBLIC on GitHub)
2. **SYNC BEFORE EXIT** - Always sync before stopping
3. **READ BEFORE ACTING** - Always check brain first
4. **WRITE LESSONS** - Always document what you learned
5. **UNIFORMITY** - All agents follow the same AGENTS.md

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

# Problem Tree: Hermes + Paperclip Integration

## The Problem
When using Paperclip web UI with Hermes agent:
- Chat shows "failed to render"
- Agent doesn't execute tasks autonomously
- Hermes asks questions instead of taking action
- Model rate limits cause failures without proper fallback

## Root Causes Identified

### 1. Chat Render Failure
**Symptom:** "Chat: failed to render" in Paperclip web GUI

**Investigation:**
- hermes-paperclip-adapter IS installed in node_modules
- `/adapters/hermes_local/models` API returns valid data (7 models)
- Chat UI plugin loads successfully (logs show "Chat plugin started")
- Workers crash with SIGTERM periodically

**Likely Root Cause:** 
- Chat plugin has a bug or missing dependency
- Transcript parsing from Hermes output fails
- Frontend can't render the response format

**Next Steps:**
- Check browser console for JS errors
- Check chat plugin logs more closely
- Try different Hermes agent configuration

### 2. Hermes Not Autonomous
**Symptom:** Hermes asks questions, doesn't take action

**Root Causes:**
1. Default SOUL.md makes it a "helpful chatbot" not action-oriented
2. `tool_use_enforcement` not enabled
3. Approval prompts enabled by default
4. Model not forced to use tools

**Fixes Applied:**
- Updated SOUL.md to be action-oriented
- Set `tool_use_enforcement: true`
- Set `approvals.mode: "off"` 
- Set `HERMES_YOLO_MODE=true`

### 3. Model Rate Limits Not Rotating
**Symptom:** When primary model (qwen free) hits 429, Hermes fails instead of rotating to fallback

**Root Causes:**
1. Fallback config wasn't using proper format
2. `base_url` and `api_key_env` weren't passed to provider resolver
3. Some fallback models don't support tool calling

**Fixes Applied:**
- Fixed fallback_model config in config.yaml
- Patched run_agent.py to pass base_url/api_key_env
- Configured chain: qwen → gpt-4o-mini (fails with encrypted content) → llama-3.3-70b-versatile (works)

### 4. Pip Externally Managed Environment
**Symptom:** "externally managed environment" when Hermes tries to pip install

**Root Cause:**
- Ubuntu 25.10 has PEP 668 - blocks system pip installs
- Hermes agent tries to run `pip install` in wrong Python environment

**Fix Applied:**
- Created ~/.config/pip/pip.conf with `break-system-packages = true`
- Hermes should now be able to install packages

## Actions Taken

| Issue | Fix | Status |
|-------|-----|--------|
| Chat render fail | Investigating - adapter loads, chat plugin loads | 🔴 Need more info |
| Not autonomous | Updated SOUL.md, enabled YOLO mode | 🟡 May need restart |
| Rate limits | Fixed fallback chain config + code patch | 🟢 Fixed |
| Pip install | Added pip config | 🟢 Fixed |

## Questions to Answer

1. What exact error shows in browser DevTools when "Chat: failed to render" appears? - **ANSWERED:** React5.useSyncExternalStore not a function - Paperclip TanStack Query bug
2. Does the issue occur with all Hermes agents or just specific one?
3. Are there any JavaScript errors in the browser console? - **ANSWERED:** See above

## Latest Issues Found

### Issue 4: Agent Permission Rejected
**Symptom:** "The user rejected permission to use this specific tool call"

**Error:** `permission requested: external_directory (/home/unclehowell/.aws/*); auto-rejecting`

**Root Cause:** 
- Paperclip has security that blocks agents from accessing external directories
- Hermes tried to access ~/.aws/ for AWS credentials
- Paperclip auto-rejected this (correct security behavior!)
- Hermes IS using --yolo flag (adapter line 317)

**Note:** This is actually GOOD - Hermes shouldn't have access to AWS credentials

### Issue 5: Chat React Error  
**Symptom:** `TypeError: React5.useSyncExternalStore is not a function`

**Root Cause:** Paperclip chat plugin has TanStack Query incompatibility with React 19

**Fix:** This is a Paperclip bug - need to report to Paperclip or wait for update

## Test Commands

```bash
# Check if adapter is working
curl http://localhost:3100/api/companies/<id>/adapters/hermes_local/models

# Check Paperclip logs
tail -f /home/unclehowell/.paperclip/instances/default/logs/server.log | grep -i hermes

# Test Hermes directly
hermes chat --profile unclehowell
```

---
*Last updated: 2026-04-01*

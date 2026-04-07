# Silent Messaging (Tool Call Suppression)

## Problem
Tool call progress messages were being forwarded to WhatsApp and Telegram platforms.
This included messages like "🐍 execute_code" with code snippets, which triggers 
WhatsApp spam detection and Telegram rate limiting.

Example spam:
- "🐍 execute_code: "from hermes_tools import read_file...""
- "🔧 terminal: grep -rn tool_call..."

## Root Cause
In gateway/run.py, the `display.tool_progress` config controls whether tool lifecycle
events are forwarded to messaging platforms. Default value was `"all"` which sends
every tool call with emoji (snake for python, wrench for terminal, etc).

The flow:
1. Agent executes a tool → triggers `progress_callback` event
2. Event queued into `progress_queue`
3. `send_progress_messages()` async loop reads queue
4. `adapter.send()` forwards to platform (WhatsApp/Telegram)
5. Each tool call = one message, causing spam

## Fix Applied
Set `display.tool_progress: "off"` in config.yaml for all 5 agents:
- ~/.hermes/config.yaml (default)
- ~/hermes_cmd_agent1-4/config.yaml (cmd agents)

This completely disables the `tool_progress_enabled` flag in gateway/run.py line 6229:
```python
tool_progress_enabled = progress_mode != "off" and source.platform != Platform.WEBHOOK
```

With `progress_mode="off"`, the condition is False, `progress_queue=None`,
and `progress_callback` becomes a no-op.

## Config Change
```yaml
display:
  tool_progress: off
  tool_progress_command: false
```

## Verification
- All 5 gateway services restarted successfully
- No tool call messages should appear on WhatsApp/Telegram going forward
- Gateway log shows tool_progress_enabled=False for each session

## Env Var Override Check
Confirmed no HERMES_TOOL_PROGRESS or HERMES_TOOL_PROGRESS_MODE env vars 
set in any .env or gateway.env files.

## Related Code
- gateway/run.py:6218-6229 - config read and progress_mode resolution
- gateway/run.py:6232 - progress_queue creation (disabled when off)
- gateway/run.py:6250-6299 - progress_callback (no-op when queue is None)
- gateway/run.py:6456-6470 - _status_callback_sync (separate channel)
- hermes_cli/config.py:1537-1552 - config migration (HERMES_TOOL_PROGRESS → display.tool_progress)

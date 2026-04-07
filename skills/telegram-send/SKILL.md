---
name: telegram-send
description: Send messages via Telegram Bot API from the command line. Supports multi-profile setups with different bot tokens. Also covers gateway (interactive bot) troubleshooting.
---

# Telegram Bot Messaging

Send messages to Telegram users/channels using the Bot API via curl, or troubleshoot the Hermes gateway for interactive bot conversations.

## Outbound Messages (curl API)

```bash
# 1. Find the chat ID (user or group)
curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates"

# Look for "chat": {"id": NUMERIC_ID, ...} in the response

# 2. Send a message
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=CHAT_ID" \
  -d "text=Your message here"

# Send with Markdown formatting
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=CHAT_ID" \
  -d "text=*bold* _italic_ [link](https://example.com)" \
  -d "parse_mode=Markdown"
```

## Finding Bot Tokens by Profile

Profile `.env` files are at `~/.hermes/profiles/<name>/.env`. The token variable is defined in `config.yaml` as `telegram.bot_token: "${VAR_NAME}"`. Common mappings:

| Profile | .env Variable |
|---------|---------------|
| unclehowell (main) | `TELEGRAM_BOT_TOKEN` |
| microwave | `MICROWAVE_TELEGRAM_BOT_TOKEN` (also `TELEGRAM_BOT_TOKEN`) |
| nvidia | `TELEGRAM_BOT_TOKEN` |

## Common Chat IDs

| User/Group | Chat ID | Notes |
|------------|---------|-------|
| @unclehowell | 5837518218 | Main user (Sion Buckler) |

## Gateway (Interactive Bot) Troubleshooting

If you reply to the bot and get no response, outbound `sendMessage` via curl may work but the **gateway** (the long-running process that polls Telegram and generates AI responses) may have issues.

### Check gateway status

```bash
systemctl --user list-units 'hermes-gateway*'
hermes gateway status
```

### Check gateway logs

```bash
# Per-profile gateway log (most useful)
cat ~/.hermes/profiles/<profile>/logs/gateway.log | tail -40

# Error log
cat ~/.hermes/profiles/<profile>/logs/errors.log

# Journal logs
journalctl --user -u hermes-gateway-<profile>.service --no-pager | tail -40
```

### Common gateway issues

1. **API key not set (most common)** — Check `profiles/<name>/logs/errors.log`. If you see `OPENROUTER_API_KEY not set` or `401 Invalid API Key`, the gateway can't call the LLM. Fix by ensuring the profile's `.env` has valid API keys and restart the gateway.

   **Important**: If the `.env` file shows `OPENROUTER_API_KEY=***`, the literal stored value is three asterisks — not a masked display. This happens when keys have been scrubbed (e.g., during migration or security sweeps). The gateway will start, poll Telegram correctly, but fail silently on every LLM response. You must provide a real API key.

2. **DNS/network failures** — Log messages like `Temporary failure in name resolution` or `All connection attempts failed`. The gateway auto-retries with fallback IPs (149.154.167.220). Check if the issue resolves or if there's a broader network problem.

3. **Polling conflicts (409 Conflict)** — `terminated by other getUpdates request; make sure that only one bot instance is running`. Multiple gateway instances using the same bot token. Restart with `hermes gateway restart`.

4. **No log file created** — If `profiles/<name>/logs/gateway.log` doesn't exist, the gateway may be writing logs to a different location or crashing before file creation. Check journal for startup output.

5. **Check unprocessed messages** — If the user's messages appear in `getUpdates` but the gateway never responded, look at the error log for LLM/API failures:
   ```bash
   cat ~/.hermes/profiles/<profile>/logs/errors.log | tail -20
   ```

6. **Restart gateway after config changes**:
   ```bash
   systemctl --user restart hermes-gateway-<profile>.service
   ```

## Pitfalls

- **Chat ID not known**: The user must have initiated contact first (sent `/start`). Run `getUpdates` to find their chat ID.
- **Wrong env var**: Different profiles use different `.env` variable names. Always check the profile's `config.yaml` for `bot_token: "${VAR_NAME}"` to find the correct variable.
- **Outbound ≠ interactive**: Successfully sending via curl only proves the bot token works. Interactive responses require the gateway to be running with valid API keys.
- **`.env` values can be literally `***`**: Hermes masks secrets in `hermes config` output, but if the raw `.env` file on disk contains `OPENROUTER_API_KEY=***`, that's the actual stored value — not a display mask. Confirm with `cat ~/.hermes/profiles/<profile>/.env | grep KEY`.
- **HTML/Markdown parse errors**: Special characters can break formatted messages. Use plain text if uncertain.
- **Rate limiting**: ~30 msg/s for broadcasts, ~1 msg/s to the same chat.
- **Bot must be admin** for channels/groups. Private chats require the user to have messaged the bot at least once.
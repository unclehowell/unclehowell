---
name: hermes-gateway-config
description: Configure and troubleshoot Hermes gateway — API keys, platform setup, environment variable sourcing, and process management. Use when setting up messaging platforms, fixing auth errors, or resolving gateway conflicts.
version: 1.0.0
author: Hermes Agent
metadata:
  hermes:
    tags: [gateway, configuration, telegram, api-keys, troubleshooting]
---

# Hermes Gateway Configuration

## Config File Hierarchy

Hermes reads config from multiple files — **different components read different files**:

| File | Read By | Purpose |
|------|---------|---------|
| `~/.hermes/config.yaml` | Gateway, agent core | Platform configs, model settings, memory provider config |
| `~/.hermes/.env` | Gateway at startup | API keys and secrets (loaded internally by gateway) |
| `~/.hermes/gateway.env` | Shell sessions (via bashrc source) | Env vars available to ALL shell commands including opencode |
| `~/.hermes/honcho.json` | Honcho plugin (via `from_global_config()`) | Honcho API key and host config |
| `~/.hermes/honcho_api_key.env` | Shell sessions (via bashrc source) | HONCHO_API_KEY for CLI tools |

CRITICAL: Shell commands (like opencode) source `~/.bashrc` which loads `gateway.env` and `honcho_api_key.env`, but NOT `~/.hermes/.env`. The `.env` file is only read by the gateway process itself.

## Setting Up Messaging Platforms

### Telegram

1. Verify the bot token is valid:
```bash
python3 -c "
import urllib.request, json
token = '<BOT_TOKEN>'
resp = urllib.request.urlopen(f'https://api.telegram.org/bot{token}/getMe', timeout=5)
print(json.loads(resp.read()))
"
```

2. Add telegram to `~/.hermes/config.yaml`:
```yaml
platforms:
  telegram:
    enabled: true
    token: "<BOT_TOKEN>"
    allow_all: true  # or set allowed_users below
```

3. Set the token in both `.env` AND `gateway.env`:
```bash
# In ~/.hermes/.env (read by gateway directly)
TELEGRAM_BOT_TOKEN=<TOKEN>

# In ~/.hermes/gateway.env (sourced by bashrc for shell commands)
TELEGRAM_BOT_TOKEN=<TOKEN>
```

4. Set allow-all or allowlist:
```bash
# In ~/.hermes/.env
TELEGRAM_ALLOW_ALL_USERS=true
# OR
TELEGRAM_ALLOWED_USERS=5837518218
GATEWAY_ALLOW_ALL_USERS=true
```

### Common Error: "Another local Hermes gateway is already using this Telegram bot token"

This is **NOT a 401 auth error**. It means multiple gateway processes are running and competing for the same token via a scoped lock.

Fix:
```bash
# 1. Kill ALL gateway processes
sudo kill -9 $(pgrep -f 'hermes gateway run')

# 2. Wait for them to actually die
sleep 3
pgrep -f 'hermes gateway run' || echo "ALL DEAD"

# 3. Clear any webhook port conflicts
sudo fuser -k 8644/tcp 2>/dev/null

# 4. Start a SINGLE gateway instance
cd ~/.hermes/hermes-agent && bash ~/.hermes/gateway-run.sh > /tmp/gateway-start.log 2>&1 &

# 5. Verify it started cleanly
sleep 5
tail -20 /tmp/gateway-start.log
grep 'connected\|failed' /home/ubuntu/.hermes/logs/gateway.log | tail -10
```

### WhatsApp

WhatsApp shows the same lock conflict if two gateways run. Same fix as above.

## Setting Up API Keys

### OpenAI (for opencode and agents)

The key must be in `gateway.env` so shell sessions can see it:
```bash
# Add to ~/.hermes/gateway.env
OPENAI_API_KEY=sk-proj-...

# Also in ~/.hermes/.env (for gateway's direct use)
OPENAI_API_KEY=sk-proj-...
```

After updating, new shell sessions will pick it up via bashrc sourcing.

### Honcho

Three files must have matching keys:
```bash
# 1. ~/.hermes/honcho.json
{"hosts": {"hermes": {...}}, "apiKey": "hch-v3-..."}

# 2. ~/.hermes/honcho_api_key.env
HONCHO_API_KEY=hch-v3-...

# 3. ~/.hermes/config.yaml
honcho:
  api_key: hch-v3-...
```

After updating keys, the gateway must be restarted.

## Gateway Process Management

### Start
```bash
cd ~/.hermes/hermes-agent && bash ~/.hermes/gateway-run.sh > /tmp/gateway-start.log 2>&1 &
```

### Stop
```bash
sudo kill -9 $(pgrep -f 'hermes gateway run')
# Verify
pgrep -f 'hermes gateway run' || echo "ALL DEAD"
```

### Check status
```bash
ps aux | grep '[h]ermes gateway run'
tail -20 /home/ubuntu/.hermes/logs/gateway.log
```

## Adding a New Platform to config.yaml

When `config.yaml` is missing the `platforms` section entirely:
```python
import yaml
config_path = "~/.hermes/config.yaml"
cfg = yaml.safe_load(open(config_path))
cfg.setdefault("platforms", {})
cfg["platforms"]["telegram"] = {
    "enabled": True,
    "token": "<TOKEN>",
    "allow_all": True,
}
with open(config_path, "w") as f:
    yaml.dump(cfg, f, default_flow_style=False)
```

## Troubleshooting Checklist

1. **"No bot token configured"**: Token missing from `config.yaml` platforms section
2. **"Another gateway already using this token"**: Kill all gateway processes, start one
3. **"Port already in use"**: Clear the port with `sudo fuser -k <port>/tcp`
4. **API key not found**: Check which file the component actually reads (see hierarchy table)
5. **Honcho initialization failed**: Check all 3 config files have the full (non-truncated) key

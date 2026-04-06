---
name: hermes-profile-audit
description: Audit and clean up Hermes agent profiles — fix hardcoded keys, add explicit telegram config, resolve gateway/session mismatches. Use when adding new bots, after migration, or when profiles behave unexpectedly.
category: devops
---

# Hermes Profile Audit and Cleanup

## When to run this
- Adding a new bot (Telegram, Discord, etc.)
- After migrating from another system
- When sessions land in the wrong profile
- Periodic security review

## Systematic Approach

### Step 1: Map all profiles and gateways
```bash
# List all profiles
ls ~/.hermes/profiles/

# List all gateway services
systemctl --user list-unit-files | grep hermes-gateway

# Check which profiles are RUNNING vs dead
for svc in $(systemctl --user list-unit-files | grep hermes-gateway | awk '{print $1}'); do
    state=$(systemctl --user show -p ActiveState --value $svc)
    echo "  $svc: $state"
done
```

### Step 2: Check profile config against running process
```bash
# Find the active gateway PID
ps aux | grep "hermes_cli.main gateway" | grep -v grep

# Check which profile the running gateway uses
cat /proc/<PID>/environ | tr '\0' '\n' | grep HERMES_HOME

# Check where sessions actually land
for p in $(ls ~/.hermes/profiles/); do
    echo "=== $p ==="
    python3 -c "
import json, glob
for sf in glob.glob('$HOME/.hermes/profiles/$p/sessions/sessions.json'):
    with open(sf) as f:
        sessions = json.load(f)
    for k, v in sessions.items():
        print(f'  {k}: updated={v.get(\"updated_at\", \"?\")} platform={v.get(\"platform\", \"?\")}')
" 2>/dev/null || echo "  no sessions"
done
```

Key finding: Active sessions must be in the same profile as the running gateway. If not, sessions are orphaned.

### Step 3: Audit for hardcoded secrets
```bash
# Find all hardcoded API keys (should use api_key_env, not api_key)
for p in ~/.hermes/profiles/*/config.yaml; do
    echo "=== $(dirname $p | xargs basename) ==="
    grep -n "api_key:" "$p" | grep -v "api_key_env"
done

# Find custom_providers with hardcoded keys
for p in ~/.hermes/profiles/*/config.yaml; do
    grep -A3 "custom_providers" "$p" | grep "api_key:"
done
```

Fix: Replace `api_key: actual_value` with `api_key_env: VAR_NAME`
Then put the actual value in the profile's .env file or ~/.hermes/.env

### Step 4: Ensure explicit telegram config in each profile
```bash
# Check if profiles have their own telegram section
for p in ~/.hermes/profiles/*/config.yaml; do
    echo "=== $(dirname $p | xargs basename) ==="
    grep -A2 "^telegram:" "$p" || echo "  NO explicit telegram (inherits from global)"
done
```

Each profile needs:
```yaml
telegram:
  bot_token: "${TELEGRAM_BOT_TOKEN}"  # or "${PROFILE_NAME_TELEGRAM_BOT_TOKEN}" for secondary bots
```

The global config.yaml should NOT carry additional_bots — each profile owns its bot.

### Step 5: Add bot tokens to .env files
For each profile that has a unique bot:
```bash
echo "TELEGRAM_BOT_TOKEN=bot:full_token_here" >> ~/.hermes/profiles/<profile>/.env
```

### Step 5b: Verify config key names (CRITICAL)
The gateway config parser uses specific key names. Common mismatches:
- **`bot_token:` is WRONG** — must be `token:`
- **Missing `allowed_users:`** — gateway silently rejects messages from unknown users
- **`enabled: true`** must be present in the telegram section

Correct telegram section format:
```yaml
telegram:
  enabled: true
  token: "bot:123456:ABC..."   # NOT bot_token
  allowed_users:
    - 5837518218               # User chat_id
```

The env var in .env must be named `TELEGRAM_BOT_TOKEN` (gateway reads this via config interpolation).

**Symptom of wrong key name:** Gateway says "No messaging platforms enabled" even though `enabled: true` is in the config. Fix: `sed -i 's/bot_token:/token:/g' ~/.hermes/profiles/*/config.yaml`

### Step 5c: Verify pairing status
If a bot responds with "I don't recognize you yet! Here's your pairing code:", the user hasn't been approved yet:
```bash
hermes pairing approve telegram <CODE>
```
Pairing codes expire quickly — the gateway agent must be running continuously for the approval to stick before the user reconnects.

### Step 6: Restart gateways after changes
```bash
# Restart the specific profile gateway
systemctl --user restart hermes-gateway-<profile>.service

# Verify it started
systemctl --user status hermes-gateway-<profile>.service --no-pager -n 3

# Check the new process environment
PID=$(ps aux | grep "hermes_cli.main gateway" | grep -v grep | head -1 | awk '{print $2}')
cat /proc/$PID/environ | tr '\0' '\n' | grep HERMES_HOME
```

### Step 7: Archive orphaned session learnings to brain
```bash
# If sessions are in a dead profile, archive their memory
# The session memory lives in ~/.hermes/profiles/<profile>/sessions/
# Key learnings should be moved to ~/.hermes/brain/memory/archive/learned/
```

## Pitfalls
- Profiles inherit telegram from global config.yaml if no explicit section — this causes bot routing confusion
- Hardcoded keys in custom_providers are invisible to the main model key check
- The gateway process env (HERMES_HOME) must match where you expect sessions
- `--replace` flag on gateway run kills any other gateway on the same bot
- Multiple gateways can run if they use different bot tokens

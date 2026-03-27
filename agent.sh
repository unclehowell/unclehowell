#!/bin/bash
# --- UNCLE HOWELL OMNI-AGENT ENGINE (v2.0) ---
AGENT="${1:-unknown}"
shift
USER_QUERY="$@"

BRAIN_DIR="$HOME/brain"
LOG_FILE="$BRAIN_DIR/logs/failover.log"
PROVIDERS_JSON="$BRAIN_DIR/providers.json"
CORE_MEM="$BRAIN_DIR/memory/core.md"
CURRENT_CTX="$BRAIN_DIR/context/current.md"

# 1. Ensure directories exist
mkdir -p "$BRAIN_DIR/logs" "$BRAIN_DIR/learned/$(date +%Y-%m-%d)"

# 2. Build the Hive Mind Context
SYSTEM_PROMPT="COLLECTIVE MEMORY: $(cat $CORE_MEM 2>/dev/null) \n CURRENT MISSION: $(cat $CURRENT_CTX 2>/dev/null) \n INSTRUCTION: Wrap new facts in <learn>...</learn> tags."

# 3. Tiered API Execution
# We iterate through the providers.json
RESPONSE=""
SUCCESS=false

# Load API keys from .env if it exists
[ -f "$BRAIN_DIR/.env" ] && export $(grep -v '^#' "$BRAIN_DIR/.env" | xargs)

# Simple loop for the top tiers (Expandable via providers.json)
for PROVIDER in "Groq" "Cerebras" "Google" "DeepSeek"; do
    echo "[$(date +%T)] Attempting $PROVIDER..." >> "$LOG_FILE"
    # (Simplified curl logic for the demonstration - the real one uses the URL from providers.json)
    # If success: RESPONSE=$RESULT; SUCCESS=true; break
done

# 4. FINAL FALLBACK: LOCAL QWEN (OLLAMA)
if [ "$SUCCESS" = false ]; then
    echo "[$(date +%T)] ALL CLOUD TIERS FAILED. Triggering Local Qwen Fail-safe." >> "$LOG_FILE"
    RESPONSE=$(curl -s -X POST http://localhost:11434/api/generate \
      -d "{\"model\": \"qwen\", \"prompt\": \"$SYSTEM_PROMPT\n\nTask: $USER_QUERY\", \"stream\": false}" | jq -r '.response')
fi

echo "$RESPONSE"

# 5. CAPTURE & LOG
LEARNING=$(echo "$RESPONSE" | sed -n 's/.*<learn>\(.*\)<\/learn>.*/\1/p')
if [ ! -z "$LEARNING" ]; then
    echo "- [$(date +%H:%M)] $LEARNING" >> "$BRAIN_DIR/learned/$(date +%Y-%m-%d)/$AGENT.md"
    echo "• Knowledge synced to local brain."
fi

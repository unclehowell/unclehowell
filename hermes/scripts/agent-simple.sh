#!/bin/bash
# Simplified Agent Script for Uncle Howell's Brain
# Minimal working version for basic command execution

set -e

BRAIN_DIR="$HOME/brain"
MEMORY_FILE="$BRAIN_DIR/memory/core.md"
CONTEXT_FILE="$BRAIN_DIR/context/current.md"
PROVIDERS_FILE="$BRAIN_DIR/providers.json"
LOG_FILE="$BRAIN_DIR/logs/failover.log"
LEARNED_DIR="$BRAIN_DIR/learned"
AGENTS_DIR="$BRAIN_DIR/agents"

# --- Check arguments ---
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <agent_name> <agent_role> <user_request>"
    echo "Example: $0 hermes hermes-cli 'Show system status'"
    exit 0
fi

AGENT_NAME="$1"
AGENT_ROLE="$2"
USER_REQUEST="$3"
HOSTNAME=$(hostname)
TIMESTAMP=$(date +%Y-%m-%d)
AGENT_LEARNING_DIR="$LEARNED_DIR/$TIMESTAMP"

# --- Ensure Directories Exist ---
mkdir -p "$BRAIN_DIR" "$LEARNED_DIR" "$AGENTS_DIR"
touch "$MEMORY_FILE" || echo "# Memory file" > "$MEMORY_FILE"
touch "$CONTEXT_FILE" || echo "# Context file" > "$CONTEXT_FILE"
touch "$LOG_FILE" || echo "# Log file" > "$LOG_FILE"
touch "$AGENT_LEARNING_DIR" || mkdir -p "$AGENT_LEARNING_DIR" 2>/dev/null || true

# --- Basic Agent Logic ---
echo "[${TIMESTAMP}] Running agent: '$AGENT_NAME' with role: '$AGENT_ROLE' on '$HOSTNAME'"
echo "User request: $USER_REQUEST"

# --- Step 1: Try LLM Provider ---
PROVIDER_SUCCESS=false
CURRENT_RESPONSE=""

# Simple provider check - in your setup, this would call actual API providers
if [ -f "$PROVIDERS_FILE" ]; then
    echo "Using providers from: $PROVIDERS_FILE"
    PROVIDER_SUCCESS=true
    CURRENT_RESPONSE='{"choices":[{"message":{"content":"I am a working assistant. Let me help you with your request.","role":"assistant"}}]}'
else
    echo "No providers file found at: $PROVIDERS_FILE"
fi

# --- Step 2: Fallback to Local ---
if [ "$PROVIDER_SUCCESS" = false ]; then
    echo "Falling back to local processing..."
    CURRENT_RESPONSE='{"choices":[{"message":{"content":"Local processing: Working without cloud providers. Request processed locally."}}]}'
fi

# --- Step 3: Extract and Display Response ---
echo "Processing response..."
ASSISTANT_MESSAGE="I received your request: $USER_REQUEST"

if echo "$CURRENT_RESPONSE" | jq -e '.choices[0].message.content' >/dev/null 2>&1; then
    ASSISTANT_MESSAGE=$(echo "$CURRENT_RESPONSE" | jq -r '.choices[0].message.content')
fi

echo "------------ Agent Response -------------"
echo "$ASSISTANT_MESSAGE"
echo "------------ End Response ---------------"

exit 0
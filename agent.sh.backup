#!/bin/bash

# Uncle Howell Distributed Brain - Agent Script
# Mission: Interact with LLM providers, manage collective memory, and learn.

set -eo pipefail # Exit on error, exit on pipe failure, enable debugging

BRAIN_DIR="$HOME/brain"
MEMORY_FILE="$BRAIN_DIR/memory/core.md"
CONTEXT_FILE="$BRAIN_DIR/context/current.md"
PROVIDERS_FILE="$BRAIN_DIR/providers.json"
LOG_FILE="$BRAIN_DIR/logs/failover.log"
LEARNED_DIR="$BRAIN_DIR/learned"
AGENTS_DIR="$BRAIN_DIR/agents" # Directory for agent-specific scripts if needed

# --- Safety Protocol ---
# Ensure no API keys or local file paths are directly embedded in prompts or scripts.
# This script relies on environment variables for API keys.
# The 'learned' directory will store AI-generated content, not sensitive system info.

# --- Input Validation ---
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <agent_name> <agent_role> <user_request>"
    echo "Example: $0 hermes hermes-cli 'Explain how land tenure worked at Ty Mawr. Wrap any key historical facts in <learn> tags.'"
    exit 1
fi

AGENT_NAME="$1"
AGENT_ROLE="$2"
USER_REQUEST="$3" # Capture the user's request from the third argument
HOSTNAME=$(hostname)
TIMESTAMP=$(date +%Y-%m-%d)
AGENT_LEARNING_DIR="$LEARNED_DIR/$TIMESTAMP"
AGENT_SCRIPT_PATH="$AGENTS_DIR/$AGENT_NAME.sh" # For agent-specific logic if needed

# --- Ensure Directories Exist ---
mkdir -p -p -p "$BRAIN_DIR" "$MEMORY_FILE" "$CONTEXT_FILE" "$LOG_FILE" "$AGENT_LEARNING_DIR" "$AGENTS_DIR"
echo "Brain directory and logs initialized."

# --- Step 1: SYNC Collective Memory ---
echo "Syncing collective memory..."
cd "$BRAIN_DIR"
# Ensure Git is initialized before attempting pull
if [ ! -d ".git" ]; then
    echo "Git repository not initialized. Please run git init in $BRAIN_DIR first." | tee -a "$LOG_FILE"
    exit 1
fi
git pull --rebase origin main > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Git pull failed for $HOSTNAME. Attempting to continue with local state." | tee -a "$LOG_FILE"
fi
cd - > /dev/null # Return to original directory

# --- Step 2: BUILD SYSTEM PROMPT ---
echo "Building system prompt..."
SYSTEM_PROMPT=""
if [ -f "$MEMORY_FILE" ]; then
    SYSTEM_PROMPT+=$(<"$MEMORY_FILE")
    SYSTEM_PROMPT+="

"
fi
if [ -f "$CONTEXT_FILE" ]; then
    SYSTEM_PROMPT+=$(<"$CONTEXT_FILE")
    SYSTEM_PROMPT+="

"
fi

# Add agent-specific context/instructions if available
if [ -f "$AGENT_SCRIPT_PATH" ]; then
    echo "Found agent-specific script: $AGENT_SCRIPT_PATH"
    # For simplicity, we'll just indicate its presence. A more robust system
    # might source it or extract specific prompts/configs.
    SYSTEM_PROMPT+="Agent specific instructions based on $AGENT_NAME: $(<"$AGENT_SCRIPT_PATH")

"
fi

# Final prompt construction: include agent role and hostname for context
# Use the actual USER_REQUEST captured from arguments.
# Added instructions for colloquial speech and reliance on context.
FULL_PROMPT="You are agent '$AGENT_NAME' with role '$AGENT_ROLE' on host '$HOSTNAME'. Your primary goal is to respond colloquially and naturally, acting as a conversational interface to the 'Uncle Howell' brain.
Rely strictly on the provided context and memory (MEMORY_FILE, CONTEXT_FILE, and any other knowledge base information) for factual accuracy. Avoid speculation, generating unsupported information, or providing encyclopedic answers beyond what's in the brain. You are here to converse and interface with the brain's knowledge, not to be a standalone knowledge source.

$SYSTEM_PROMPT

User Request: $USER_REQUEST"
echo "System prompt built."

# --- Step 3: TIERED CALL & FALLBACK ---
echo "Attempting to call LLM providers..."
PROVIDER_SUCCESS=false
MAX_RETRIES=2 # Reduced retries for faster simulation
CURRENT_RESPONSE="" # To store the response from the LLM call

# Read providers from JSON. Ensure jq is installed.
if ! command -v jq &> /dev/null; then
    echo "Error: jq command not found. Please install jq to parse JSON." | tee -a "$LOG_FILE"
    exit 1
fi
mapfile -t PROVIDERS < <(jq -c '.[]' "$PROVIDERS_FILE")

if [ ${#PROVIDERS[@]} -eq 0 ]; then
    echo "Error: No providers found in $PROVIDERS_FILE or failed to parse." | tee -a "$LOG_FILE"
    exit 1
fi

for provider_info in "${PROVIDERS[@]}"; do
    PROVIDER_NAME=$(echo "$provider_info" | jq -r '.name')
    PROVIDER_URL=$(echo "$provider_info" | jq -r '.url')
    KEY_ENV_VAR=$(echo "$provider_info" | jq -r '.key_env_var')

    API_KEY="${!KEY_ENV_VAR}" # Dereference environment variable

    if [ -n "$API_KEY" ]; then
        echo "Trying provider: $PROVIDER_NAME ($PROVIDER_URL)..."
        ATTEMPT=0
        while [ $ATTEMPT -lt $MAX_RETRIES ]; do
            ATTEMPT=$((ATTEMPT+1))
            # --- SIMULATION OF API CALL ---
            # In a real script, this would involve 'curl' or a dedicated SDK.
            # We simulate success for initial providers and then errors.
            RANDOM_NUM=$((RANDOM % 100))
            
            # Simulate success for first few providers, then errors.
            if [[ "$PROVIDER_NAME" == "Groq" || "$PROVIDER_NAME" == "Cerebras" || "$PROVIDER_NAME" == "SambaNova" ]] && [ $RANDOM_NUM -lt 85 ]; then
                echo "Simulating successful response from $PROVIDER_NAME."
                # Simulate a response with learning tags and a primary message
                CURRENT_RESPONSE='{
                    "id": "chatcmpl-mock-'"$PROVIDER_NAME"'-'"$ATTEMPT"'",
                    "object": "chat.completion",
                    "created": 1711500000,
                    "model": "mock-model-'"$PROVIDER_NAME"'-'"$ATTEMPT"'",
                    "choices": [
                        {
                            "index": 0,
                            "message": {
                                "role": "assistant",
                                "content": "<learn>This is a simulated learning from ''"$PROVIDER_NAME"' about the ''"$AGENT_NAME"' agent on host ''"$HOSTNAME"' ''(role: ''"$AGENT_ROLE"'').
System prompt snippet: $(echo "$SYSTEM_PROMPT" | head -n 5 | sed 's/"/"/g' | tr -d '
')
</learn>

This is the primary response for the user from '$PROVIDER_NAME'."
                            },
                            "finish_reason": "stop"
                        }
                    ],
                    "usage": {"prompt_tokens": 100, "completion_tokens": 50, "total_tokens": 150}
                }'
                PROVIDER_SUCCESS=true
                break # Success, break retry loop
            else
                # Simulate 429 (Quota) or 5xx (Error)
                HTTP_STATUS=$(( (RANDOM % 2) == 0 ? 429 : 500 ))
                echo "Simulating $HTTP_STATUS error from $PROVIDER_NAME. Attempt $ATTEMPT/$MAX_RETRIES." | tee -a "$LOG_FILE"
                sleep 2 # Wait before retrying
            fi
        done

        if $PROVIDER_SUCCESS; then
            break # Success, break provider loop
        fi
    else
        echo "API key not set for $PROVIDER_NAME. Skipping."
    fi
done

# --- LOCAL FAILSAFE ---
if ! $PROVIDER_SUCCESS; then
    echo "All cloud providers failed or had no API keys. Falling back to Ollama (phone:192.168.1.42:11434)..."
    export OLLAMA_HOST="http://192.168.1.42:11434"
    OLLAMA_URL="http://192.168.1.42:11434/api/generate"
    OLLAMA_MODEL="smollm:135m" 
    
    echo "Calling Ollama on phone at $OLLAMA_URL with model $OLLAMA_MODEL..."
    JSON_PROMPT=$(jq -n --arg p "$FULL_PROMPT" '$p')
    OLLAMA_RESPONSE=$(curl -s --max-time 120 "$OLLAMA_URL" -d "{\"model\":\"$OLLAMA_MODEL\",\"prompt\":$JSON_PROMPT,\"stream\":false}" 2>&1)
    
    if [ $? -eq 0 ] && [ -n "$OLLAMA_RESPONSE" ]; then
        echo "Ollama response received."
        CURRENT_RESPONSE="$OLLAMA_RESPONSE"
        PROVIDER_SUCCESS=true
    else
        echo "Ollama call failed: $OLLAMA_RESPONSE" | tee -a "$LOG_FILE"
        CURRENT_RESPONSE='{"error": "Ollama failure: could not connect or model not found."}'
    fi
fi

# --- STEP 4: CAPTURE LEARNINGS ---
if $PROVIDER_SUCCESS; then
    echo "Processing response for learnings..."
    # Extract learning content using grep. This is a basic extraction.
    # It assumes <learn>...</learn> tags are on single lines or can be parsed this way.
    LEARNING_CONTENT=$(echo "$CURRENT_RESPONSE" | grep -oP '<learn>\K.*?(?=</learn>)' | sed 's/
/
/g')

    if [ -n "$LEARNING_CONTENT" ]; then
        echo "Found learning content. Appending to $AGENT_LEARNING_DIR/$AGENT_NAME.md"
        mkdir -p -p -p "$AGENT_LEARNING_DIR" # Ensure directory exists
        # Append learning content, maintaining format
        echo "--- Learning from $PROVIDER_NAME (or Ollama Fallback) on $TIMESTAMP ---" >> "$AGENT_LEARNING_DIR/$AGENT_NAME.md"
        echo "$LEARNING_CONTENT" >> "$AGENT_LEARNING_DIR/$AGENT_NAME.md"
        echo "Learnings captured."
    else
        echo "No learning content found in the response."
    fi

    # Display the primary response part from the LLM
    ASSISTANT_MESSAGE=""
    if echo "$CURRENT_RESPONSE" | jq -e '.choices[0].message.content' > /dev/null; then
        ASSISTANT_MESSAGE=$(echo "$CURRENT_RESPONSE" | jq -r '.choices[0].message.content')
    elif echo "$CURRENT_RESPONSE" | jq -e '.response' > /dev/null; then
        ASSISTANT_MESSAGE=$(echo "$CURRENT_RESPONSE" | jq -r '.response')
    fi

    if [ -n "$ASSISTANT_MESSAGE" ]; then
        echo "--- Agent Output ---"
        echo "$ASSISTANT_MESSAGE" | grep -v '<learn>' # Hide the learning tags in the final output
        echo "--------------------"
    else
        echo "Could not extract assistant message from response."
        echo "Raw response: $CURRENT_RESPONSE"
    fi
else
    echo "All LLM provider calls failed. No response generated or learnings captured." | tee -a "$LOG_FILE"
fi

echo "Agent script finished."
exit 0

#!/bin/bash

# NVIDIA Kimi K2.5 - Idle Agent Takeover Script
# Monitors agents and takes over tasks from idle ones

set -e

BRAIN_DIR="$HOME/brain"
AGENT_DIR="$BRAIN_DIR/agents/nvidia-kimi"
WORKSPACE="$AGENT_DIR/workspace"
PROVIDERS_FILE="$BRAIN_DIR/providers.json"
LOG_FILE="$AGENT_DIR/logs/takeover.log"
STATUS_FILE="$AGENT_DIR/status.json"

NVIDIA_API_KEY="${NVAPI_KEY}"
NVIDIA_URL="https://integrate.api.nvidia.com/v1/chat/completions"
MODEL="moonshotai/kimi-k2.5"

IDLE_THRESHOLD=300  # 5 minutes in seconds
CHECK_INTERVAL=60   # Check every 60 seconds

mkdir -p "$AGENT_DIR/logs" "$WORKSPACE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

get_last_activity() {
    local agent_path="$1"
    local last_file="$agent_path/.last_activity"
    if [ -f "$last_file" ]; then
        cat "$last_file"
    else
        echo "0"
    fi
}

set_last_activity() {
    local agent_path="$1"
    echo "$(date +%s)" > "$agent_path/.last_activity"
}

is_agent_idle() {
    local agent_path="$1"
    local last_active=$(get_last_activity "$agent_path")
    local current_time=$(date +%s)
    local idle_time=$((current_time - last_active))
    [ $idle_time -ge $IDLE_THRESHOLD ]
}

get_pending_tasks() {
    local agent_path="$1"
    local tasks=()
    
    # Check for task files
    for task_file in "$agent_path"/tasks/*.md "$agent_path"/workspace/tasks/*.md 2>/dev/null; do
        if [ -f "$task_file" ]; then
            local status=$(grep -m1 "^status:" "$task_file" 2>/dev/null | cut -d: -f2 | tr -d ' ')
            if [ "$status" = "pending" ] || [ "$status" = "in_progress" ]; then
                tasks+=("$task_file")
            fi
        fi
    done
    
    printf '%s\n' "${tasks[@]}"
}

call_nvidia_kimi() {
    local prompt="$1"
    
    if [ -z "$NVIDIA_API_KEY" ]; then
        log "ERROR: NVAPI_KEY not set"
        return 1
    fi
    
    curl -s "$NVIDIA_URL" \
        -H "Authorization: Bearer $NVIDIA_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"$MODEL\",
            \"messages\": [{\"role\": \"user\", \"content\": $prompt}],
            \"stream\": false
        }" 2>&1
}

claim_task() {
    local task_file="$1"
    local agent_name="$2"
    
    log "Claiming task: $task_file from idle agent: $agent_name"
    
    # Mark task as being worked by NVIDIA-Kimi
    sed -i "s/^status:.*/status: in_progress_by_nvidia_kimi/" "$task_file" 2>/dev/null
    echo "" >> "$task_file"
    echo "Taken over by: NVIDIA-Kimi at $(date)" >> "$task_file"
    
    # Copy task to our workspace
    cp "$task_file" "$WORKSPACE/claimed_$(basename $task_file)"
}

execute_task() {
    local task_file="$1"
    local task_content=$(cat "$task_file")
    
    log "Executing task: $task_content"
    
    # Call NVIDIA Kimi to process the task
    local escaped_content=$(echo "$task_content" | jq -Rs .)
    local response=$(call_nvidia_kimi "Execute this task and report completion: $escaped_content")
    
    if [ $? -eq 0 ]; then
        log "Task completed by NVIDIA Kimi"
        echo "$response" >> "$task_file.completed"
        
        # Mark original task as complete
        sed -i "s/status:.*/status: completed_by_nvidia_kimi/" "$task_file" 2>/dev/null
        return 0
    else
        log "Task execution failed: $response"
        return 1
    fi
}

check_agents() {
    local agents=(
        "/home/unclehowell/.openclaw/agents/tinker"
        "/home/unclehowell/.openclaw/agents/main"
        "/home/unclehowell/.opencode"
        "/home/unclehowell/.paperclip/instances/default/workspaces"
    )
    
    for agent in "${agents[@]}"; do
        if [ -d "$agent" ]; then
            if is_agent_idle "$agent"; then
                log "Agent is idle: $agent"
                tasks=$(get_pending_tasks "$agent")
                if [ -n "$tasks" ]; then
                    while IFS= read -r task; do
                        [ -z "$task" ] && continue
                        claim_task "$task" "$agent"
                        execute_task "$task"
                    done <<< "$tasks"
                fi
            fi
        fi
    done
}

# Main monitoring loop
log "NVIDIA Kimi Idle Monitor started"
log "Using model: $MODEL"
log "Idle threshold: ${IDLE_THRESHOLD}s"

while true; do
    check_agents
    sleep $CHECK_INTERVAL
done

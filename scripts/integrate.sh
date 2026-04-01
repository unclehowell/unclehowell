#!/bin/bash
# Universal Brain Integration
# Source this in any agent startup to enable brain features

BRAIN_DIR="${BRAIN_DIR:-/home/unclehowell/brain}"

# Pull latest brain
pull_brain() {
    cd "$BRAIN_DIR" 2>/dev/null || return
    git fetch origin 2>/dev/null
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse origin/main 2>/dev/null || git rev-parse origin/master 2>/dev/null)
    if [ "$LOCAL" != "$REMOTE" ] && [ -n "$REMOTE" ]; then
        echo "📥 Brain updated from GitHub"
        git reset --hard origin/main 2>/dev/null || git reset --hard origin/master 2>/dev/null
    fi
}

# Get brain context for current task
get_brain_context() {
    local context_file="$BRAIN_DIR/memory/core.md"
    local soul_file="$BRAIN_DIR/memory/soul.md"
    local providers_file="$BRAIN_DIR/providers.json"
    
    echo "=== 🧠 BRAIN CONTEXT ==="
    [ -f "$soul_file" ] && cat "$soul_file"
    echo ""
    [ -f "$context_file" ] && cat "$context_file"
    echo ""
    [ -f "$providers_file" ] && cat "$providers_file"
}

# Save learned lesson
learn() {
    local lesson="$1"
    local category="${2:-general}"
    local agent="${3:-unknown}"
    # Use Hermes memory tool if available, otherwise use archived location
    local filename="$BRAIN_DIR/memory/archive/learned/$(date '+%Y-%m-%d')/$agent.md"
    
    mkdir -p "$BRAIN_DIR/memory/archive/learned/$(date '+%Y-%m-%d')"
    
    cat >> "$filename" << EOFA
### $(date '+%Y-%m-%d %H:%M') - $agent [$category]
$lesson

EOFA
    echo "💾 Saved to brain: $category (legacy - prefer Hermes memory tool)"
}

# Recall from brain
recall() {
    local query="$1"
    echo "=== 🔍 Brain recall: $query ==="
    grep -ri "$query" "$BRAIN_ROOT/memory/" "$BRAIN_ROOT/memory/archive/learned/" 2>/dev/null | head -10 || echo "No matches"
}

# Check for relevant learnings before task
before_task() {
    local task="$1"
    recall "$task"
}

# Save lesson after task completion
after_task() {
    local outcome="$1"
    local what_worked="$2"
    local what_didnt="$3"
    learn "Task: $outcome | Worked: $what_worked | Didn't: $what_didnt" "task-outcome"
}

# Initialize
pull_brain

# Export
export -f pull_brain
export -f get_brain_context
export -f learn
export -f recall
export -f before_task
export -f after_task
export BRAIN_DIR

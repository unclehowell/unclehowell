#!/bin/bash
# Brain Hook - Source this in any agent to use shared brain
# Add to top of agent scripts: source \$\{BRAIN_DIR:-/home/ubuntu/datro/static/brain\}/scripts/hook.sh

BRAIN_DIR="${BRAIN_DIR:-/home/ubuntu/datro/static/brain}"
AGENT_NAME="${1:-unknown}"
CURRENT_TASK="$2"

# Pull latest brain
pull_brain() {
    cd "$BRAIN_DIR" 2>/dev/null || return
    git fetch origin 2>/dev/null
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse origin/main 2>/dev/null)
    if [ "$LOCAL" != "$REMOTE" ] && [ -n "$REMOTE" ]; then
        echo "📥 Brain updated locally"
        git reset --hard origin/main 2>/dev/null
    fi
}

# Save learned lesson to brain
learn() {
    local lesson="$1"
    local category="${2:-general}"
    local timestamp=$(date '+%Y-%m-%d %H:%M')
    # Use Hermes memory tool if available, otherwise use archived location
    local filename="$BRAIN_DIR/memory/archive/learned/$(date '+%Y-%m-%d')/$AGENT_NAME.md"
    
    mkdir -p "$BRAIN_DIR/memory/archive/learned/$(date '+%Y-%m-%d')"
    
    cat >> "$filename" << EOF
### $timestamp - $AGENT_NAME
$lesson

EOF
    echo "💾 Lesson saved to brain: $category (legacy - prefer Hermes memory tool)"
}

# Get relevant memory for current task
recall() {
    local query="${1:-}"
    local results=""
    
    # Search in memory
    if [ -d "$BRAIN_DIR/memory" ]; then
        results=$(grep -ri "$query" "$BRAIN_DIR/memory/" 2>/dev/null | head -5)
    fi
    
    # Search in learned (archived location)
    if [ -d "$BRAIN_DIR/memory/archive/learned" ]; then
        results="$results"$(grep -ri "$query" "$BRAIN_DIR/memory/archive/learned/" 2>/dev/null | head -5)
    fi
    
    echo "$results"
}

# Get core brain knowledge
brain_context() {
    local context_file="$BRAIN_DIR/memory/core.md"
    local providers_file="$BRAIN_DIR/providers.json"
    
    echo "=== BRAIN CONTEXT ==="
    [ -f "$context_file" ] && cat "$context_file"
    echo ""
    echo "=== PROVIDERS ==="
    [ -f "$providers_file" ] && cat "$providers_file" 2>/dev/null || echo "{}"
}

# Print brain summary for agent startup
brain_summary() {
    echo "=== 🧠 BRAIN STATUS ==="
    echo "Brain: $BRAIN_DIR"
    echo "Last sync: $(git -C "$BRAIN_DIR" log -1 --format='%h %ci' 2>/dev/null || echo 'Never')"
    echo ""
    echo "Memory files: $(find "$BRAIN_DIR/memory" -type f 2>/dev/null | wc -l)"
    echo "Learned today (archived): $(find "$BRAIN_DIR/memory/archive/learned/$(date '+%Y-%m-%d')" -type f 2>/dev/null | wc -l)"
    echo ""
}

# Auto-pull on source
pull_brain

# Export functions
export -f learn
export -f recall  
export -f brain_context
export BRAIN_DIR

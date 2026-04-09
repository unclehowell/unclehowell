#!/bin/bash
# Brain auto-hook for all shells
# Add to ~/.bashrc: source \$\{BRAIN_DIR:-/home/ubuntu/datro/static/brain\}/scripts/auto_hook.sh

BRAIN_DIR="${BRAIN_DIR:-/home/ubuntu/datro/static/brain}"

# Pull brain on shell start
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

# Save lesson
learn() {
    local lesson="$1"
    local category="${2:-general}"
    local filename="$BRAIN_DIR/memory/archive/learned/$(date '+%Y-%m-%d')/cli.md"
    mkdir -p "$BRAIN_DIR/memory/archive/learned/$(date '+%Y-%m-%d')"
    echo "### $(date '+%H:%M') - $category" >> "$filename"
    echo "$lesson" >> "$filename"
    echo "" >> "$filename"
    echo "💾 Saved to brain (legacy - prefer Hermes memory tool)"
}

# Recall
recall() {
    local query="$1"
    echo "=== Brain recall: $query ==="
    grep -ri "$query" "$BRAIN_DIR/memory/" "$BRAIN_DIR/memory/archive/learned/" 2>/dev/null | head -10
}

# Brain context
brain_ctx() {
    [ -f "$BRAIN_DIR/memory/core.md" ] && cat "$BRAIN_DIR/memory/core.md"
    [ -f "$BRAIN_DIR/providers.json" ] && cat "$BRAIN_DIR/providers.json"
}

# Aliases
alias brain='pull_brain; echo "Brain ready"'
alias recall='recall'
alias learn='learn'
alias brainctx='brain_ctx'

# Auto-pull on shell start
pull_brain

export BRAIN_DIR

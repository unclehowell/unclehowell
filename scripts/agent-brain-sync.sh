#!/bin/bash
# Agent Brain Sync Script - Each agent uses this to sync with hive mind
# Run this before and after each task execution

AGENT_BRAIN_DIR="${1:-.}"
BRAIN_REPO="git@github-unclehowell:unclehowell/unclehowell.git"
BRANCH="main"

cd "$AGENT_BRAIN_DIR" || exit 1

echo "[Brain Sync] Syncing at $(date)"

# Stash local changes first
git stash push -m "pre-sync stash $(date +%s)" 2>/dev/null || true

# Pull latest with auto-merge
git fetch origin
git pull origin $BRANCH --no-edit || {
    # On conflict, use ours (local) for markdown files, theirs for rest
    echo "[Brain Sync] Resolving conflicts..."
    git checkout --theirs . 2>/dev/null || true
    git checkout HEAD -- . 2>/dev/null || true
    git add -A
    git commit -m "Auto-merge conflict resolved $(date)" || true
}

# Stage any local changes
git add -A

# Commit and push if there are local changes
if ! git diff --cached --quiet; then
    git commit -m "Agent update: $(date '+%Y-%m-%d %H:%M')" || true
    git push origin $BRANCH || echo "[Brain Sync] Push failed - will retry next sync"
fi

echo "[Brain Sync] Done"

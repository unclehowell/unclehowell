#!/bin/bash
# Brain Sync Service - Safely syncs brain folder to GitHub
# Pulls latest, merges, commits local changes, and pushes
# Usage: bash /home/ubuntu/datro/static/brain/scripts/sync.sh
# Can be sourced by any agent

set -euo pipefail

# Auto-detect brain dir based on home directory
user_home=$(eval echo ~$(whoami))
BRAIN_DIR="${BRAIN_DIR:-${user_home}/brain}"
BRANCH="main"

cd "$BRAIN_DIR" || exit 1

echo "[brain-sync] Sync started at $(date)"

# 1. Pull latest without destroying local changes (rebase instead of reset --hard)
echo "[brain-sync] Fetching latest..."
git fetch origin "$BRANCH" 2>/dev/null || true

# Check if there are remote changes
REMOTE_HEAD=$(git rev-parse "origin/$BRANCH" 2>/dev/null || echo "")
LOCAL_HEAD=$(git rev-parse HEAD 2>/dev/null || echo "")

if [ "$REMOTE_HEAD" != "$LOCAL_HEAD" ] && [ -n "$REMOTE_HEAD" ]; then
    echo "[brain-sync] Remote has changes, pulling..."
    git stash -m "pre-sync stash" 2>/dev/null || true
    git pull --rebase origin "$BRANCH" 2>/dev/null || {
        echo "[brain-sync] Rebase failed, trying merge..."
        git merge --no-edit origin/"$BRANCH" 2>/dev/null || {
            echo "[brain-sync] Merge conflict detected, keeping local changes"
            git merge --abort 2>/dev/null || true
        }
    }
    git stash pop 2>/dev/null || true
fi

# 2. Stage all changes
git add -A

# 3. Check if there are changes to commit
if git diff --cached --quiet && git diff --cached --staged --quiet 2>/dev/null; then
    echo "[brain-sync] No changes to commit"
else
    COMMIT_MSG="Brain update: $(date '+%Y-%m-%d %H:%M')"
    git commit -m "$COMMIT_MSG" || true
    echo "[brain-sync] Committed: $COMMIT_MSG"
fi

# 4. Push
echo "[brain-sync] Pushing to GitHub..."
git push origin "$BRANCH" 2>/dev/null && echo "[brain-sync] Pushed successfully" || {
    echo "[brain-sync] Push failed (may need authentication or has conflicts)"
}

echo "[brain-sync] Done at $(date)"

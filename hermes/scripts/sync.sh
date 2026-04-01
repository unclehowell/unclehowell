#!/bin/bash
# Brain Sync Service - Syncs brain folder to GitHub
# Run this via cron or systemd timer

BRAIN_DIR="${BRAIN_DIR:-/home/unclehowell/brain}"
GITHUB_REPO="https://github.com/unclehowell/brain.git"
BRANCH="main"

cd "$BRAIN_DIR" || exit 1

echo "=== Brain Sync: $(date) ==="

# Pull latest changes first
git fetch origin
git reset --hard origin/$BRANCH 2>/dev/null || true

# Add new learned lessons
git add -A

# Check if there are changes
if git diff --cached --quiet; then
    echo "No changes to sync"
    exit 0
fi

# Commit and push
COMMIT_MSG="Brain update: $(date '+%Y-%m-%d %H:%M')"
git commit -m "$COMMIT_MSG" || exit 0
git push origin $BRANCH

echo "Brain synced to GitHub: $COMMIT_MSG"

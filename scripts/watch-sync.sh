#!/bin/bash
# Brain Git-on-Change Sync Service
# Watches the brain directory and commits+pushes on any file change
# Usage: bash /home/ubuntu/brain/scripts/watch-sync.sh
# Runs as a background daemon - logs to /tmp/brain-watch-sync.log

set -euo pipefail

BRAIN_DIR="${BRAIN_DIR:-/home/ubuntu/brain}"
LOG_FILE="/tmp/brain-watch-sync.log"
PENDING_FILE="/tmp/brain-watch-pending"

cd "$BRAIN_DIR" || { echo "ERROR: Brain dir not found"; exit 1; }

echo "[watch-sync] Started at $(date) — watching $BRAIN_DIR" >> "$LOG_FILE"

# Initialize pending flag
touch "$PENDING_FILE"

# Coalesce changes: if a change happens while sync is running, mark pending and re-sync
while true; do
    # Wait for any file change (create, modify, delete, move)
    # -e specifies events, -r for recursive, -m for monitor (continuous)
    inotifywait -r -q \
        -e close_write -e create -e delete -e moved_to -e moved_from \
        --exclude '.git/|\.swp$|\.tmp$|__pycache__|node_modules|\.log$' \
        "$BRAIN_DIR" 2>/dev/null || true

    # Sync
    (
        flock -n 200 || exit 0  # Skip if another sync is running
        cd "$BRAIN_DIR"
        git add -A
        if git diff --cached --quiet && git diff --cached --staged --quiet 2>/dev/null; then
            echo "[watch-sync] $(date): No changes" >> "$LOG_FILE"
        else
            COMMIT_MSG="Brain update: $(date '+%Y-%m-%d %H:%M')"
            git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1 || true
            echo "[watch-sync] $(date): Committed" >> "$LOG_FILE"
            git push origin main >> "$LOG_FILE" 2>&1 || echo "[watch-sync] $(date): Push failed" >> "$LOG_FILE"
            echo "[watch-sync] $(date): Pushed" >> "$LOG_FILE"
        fi
    ) 200>/tmp/brain-sync.lock

    # Check if pending — if another change came in during sync, re-sync
    if [ -f "$PENDING_FILE" ]; then
        touch "$PENDING_FILE"  # Reset for next iteration
        continue
    fi
done

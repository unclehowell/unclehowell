#!/bin/bash
# Brain Git-on-Change Sync Service — Robust concurrent sync
# Watches brain dir, commits, and auto-rebases+pushes on conflict
set -euo pipefail

BRAIN_DIR="${BRAIN_DIR:-$HOME/brain}"
LOG_FILE="/tmp/brain-watch-sync.log"

cd "$BRAIN_DIR" || exit 1

# Configure git for automatic conflict-free rebasing
git config pull.rebase true
git config rebase.autoStash true

echo "[watch-sync] Started $(date) — watching $BRAIN_DIR" >> "$LOG_FILE"

while true; do
    # Wait for file changes (ignore .git, temp files, logs)
    inotifywait -r -q \
        -e close_write -e create -e delete -e moved_to \
        --exclude '.git/|\.swp$|\.tmp$|__pycache__|\.log$' \
        "$BRAIN_DIR" 2>/dev/null || true

    (
        flock -n 200 || exit 0
        cd "$BRAIN_DIR"
        git add -A
        if git diff --cached --quiet; then
            echo "[watch-sync] $(date): No changes" >> "$LOG_FILE"
        else
            COMMIT_MSG="Brain update: $(date '+%Y-%m-%d %H:%M')"
            git commit -m "$COMMIT_MSG" >> "$LOG_FILE" 2>&1 || true
            
            # Push, with auto-rebase fallback if remote advanced
            for i in 1 2; do
                if git push origin main >> "$LOG_FILE" 2>&1; then
                    echo "[watch-sync] $(date): Pushed" >> "$LOG_FILE"
                    break
                else
                    echo "[watch-sync] $(date): Push rejected, pulling + rebasing (attempt $i)" >> "$LOG_FILE"
                    git pull --rebase --autostash origin main >> "$LOG_FILE" 2>&1
                fi
            done || echo "[watch-sync] $(date): Sync failed after retries" >> "$LOG_FILE"
        fi
    ) 200>/tmp/brain-sync.lock
done

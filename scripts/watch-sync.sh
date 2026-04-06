#!/bin/bash
# Brain Git-on-Change Sync Service
# Uses inotifywait to detect file changes and trigger sync
# Usage: bash /home/ubuntu/brain/scripts/watch-sync.sh

set -euo pipefail

BRAIN_DIR="${BRAIN_DIR:-/home/ubuntu/brain}"
SYNC_SCRIPT="${BRAIN_DIR}/scripts/sync.sh"
LOCK_FILE="/tmp/brain_sync.lock"
DEBOUNCE_SECONDS=30

# Kill stale lock if exists
rm -f "$LOCK_FILE"

echo "[brain-watch] Started at $(date)"
echo "[brain-watch] Watching: $BRAIN_DIR"
echo "[brain-watch] Debounce: ${DEBOUNCE_SECONDS}s"

inotifywait -m -r -e modify,create,delete,move \
    --exclude '(\.git/|\.swp$|\.swx$|\.swo$|__pycache__|node_modules|\.tmp$)' \
    "$BRAIN_DIR" 2>/dev/null | while read path action file; do

    # Skip .git internal changes
    if [[ "$path" == *".git/"* ]]; then
        continue
    fi

    CURRENT_TIME=$(date +%s)

    # Debounce: skip if sync ran in last N seconds
    if [ -f "$LOCK_FILE" ]; then
        LAST_SYNC=$(cat "$LOCK_FILE" 2>/dev/null || echo 0)
        ELAPSED=$((CURRENT_TIME - LAST_SYNC))
        if [ "$ELAPSED" -lt "$DEBOUNCE_SECONDS" ]; then
            continue
        fi
    fi

    # Update lock
    echo "$CURRENT_TIME" > "$LOCK_FILE"

    echo "[$(date)] Change detected: $action $path$file — syncing..."

    # Run sync
    cd "$BRAIN_DIR" && bash "$SYNC_SCRIPT" 2>&1 | tail -5

    echo "[$(date)] Sync complete."
done

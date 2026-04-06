#!/bin/bash
# Brain sync via laptop proxy
# This server commits locally -> laptop pulls -> laptop pushes to GitHub

set -euo pipefail

BRAIN_DIR="${BRAIN_DIR:-/home/ubuntu/brain}"
LAPTOP="unclehowell@100.110.242.84"
SSH_PASS="Burgerking2407!!"
LAPTOP_BRAIN="/home/unclehowell/brain"
BRANCH="main"

cd "$BRAIN_DIR" || { echo "[proxy-sync] Brain dir not found"; exit 1; }

echo "[proxy-sync] Sync started at $(date)"

# 1. Fetch latest FROM laptop (laptop pulls from GitHub first)
echo "[proxy-sync] Fetching latest from laptop..."
sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no "$LAPTOP" "
  cd $LAPTOP_BRAIN && 
  git fetch origin $BRANCH 2>/dev/null &&
  git pull --rebase origin $BRANCH 2>/dev/null || true
"

sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no "$LAPTOP" "cat $LAPTOP_BRAIN/.git/refs/heads/$BRANCH 2>/dev/null" > /tmp/remote_head 2>/dev/null
REMOTE_HEAD=$(cat /tmp/remote_head 2>/dev/null || echo "")
LOCAL_HEAD=$(git rev-parse HEAD 2>/dev/null || echo "")

if [ "$REMOTE_HEAD" != "$LOCAL_HEAD" ] && [ -n "$REMOTE_HEAD" ]; then
    echo "[proxy-sync] Pulling changes from laptop..."
    git stash -m "pre-sync stash" 2>/dev/null || true
    git fetch /tmp/remote_repo 2>/dev/null || true
    # Hard reset to match laptop since we can't use git pull without auth
    sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no "$LAPTOP" "cd $LAPTOP_BRAIN && git reset --hard origin/$BRANCH 2>/dev/null && tar czf /tmp/brain_latest.tar.gz --exclude='.git' ." 2>/dev/null
    sshpass -p "$SSH_PASS" scp -o StrictHostKeyChecking=no "$LAPTOP:/tmp/brain_latest.tar.gz" /tmp/brain_latest.tar.gz 2>/dev/null
    if [ -f /tmp/brain_latest.tar.gz ]; then
        # Exclude .git and scripts from overwrite to preserve our local git
        cd /
        tar xzf /tmp/brain_latest.tar.gz --exclude='brain/.git' --exclude='brain/scripts/sync.sh' 2>/dev/null || true
        cd "$BRAIN_DIR"
    fi
    git stash pop 2>/dev/null || true
fi

# 2. Stage and commit local changes
git add -A
if git diff --cached --quiet; then
    echo "[proxy-sync] No changes to commit"
else
    COMMIT_MSG="Brain update: $(date '+%Y-%m-%d %H:%M')"
    git commit -m "$COMMIT_MSG" || true
    echo "[proxy-sync] Committed: $COMMIT_MSG"
    
    # 3. Push via laptop
    echo "[proxy-sync] Pushing to GitHub via laptop..."
    # Create archive of changes and send to laptop
    cd /
    tar czf /tmp/brain_changes.tar.gz brain/ 2>/dev/null
    sshpass -p "$SSH_PASS" scp -o StrictHostKeyChecking=no /tmp/brain_changes.tar.gz "$LAPTOP:/tmp/" 2>/dev/null || true
    sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no "$LAPTOP" "
      cd $LAPTOP_BRAIN &&
      rm -rf brain_temp 2>/dev/null &&
      mkdir -p brain_temp &&
      cd brain_temp &&
      tar xzf /tmp/brain_changes.tar.gz &&
      rsync -a brain/ ../ --exclude='.git' &&
      cd .. && rm -rf brain_temp &&
      git add -A &&
      git commit -m 'Brain update from aws2' --allow-empty 2>/dev/null &&
      git push origin $BRANCH 2>&1
    "
    cd "$BRAIN_DIR"
    echo "[proxy-sync] Push complete"
fi

echo "[proxy-sync] Done at $(date)"
rm -f /tmp/brain_*.tar.gz /tmp/remote_head 2>/dev/null

#!/bin/bash

# Uncle Howell Distributed Brain - Sync Script
# Mission: Commit learned data, push to GitHub, and create/merge PRs.

set -eo pipefail

BRAIN_DIR="/home/ubuntu/datro/static/brain"
LEARNED_DIR="$BRAIN_DIR/learned"
HOSTNAME=$(hostname)
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BRANCH_NAME="agent/$(echo $HOSTNAME | tr '[:upper:]' '[:lower:]')-$(date +%Y%m%d)" # Consistent branch naming, lowercase hostname
PR_TITLE="Update: $(hostname) - $(date +%Y-%m-%d)"
PR_BODY="Automated daily sync of learned data from agent $(hostname) on $(date +%Y-%m-%d)."
MAIN_BRANCH="main" # Or "master" depending on repo config

# --- Safety Protocol ---
# This script manipulates git and GitHub. Ensure no sensitive info is logged.
# Sensitive keys should be managed via environment variables, not hardcoded.

# --- Prerequisites Check ---
if ! command -v git &> /dev/null; then
    echo "Error: git command not found. Please install git." | tee -a "$BRAIN_DIR/logs/sync_fail.log"
    exit 1
fi
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) not found. Please install and authenticate gh." | tee -a "$BRAIN_DIR/logs/sync_fail.log"
    exit 1
fi
if ! git remote get-url origin | grep -q "unclehowell/unclehowell.git"; then
    echo "Warning: Git remote 'origin' is not set to unclehowell/unclehowell.git. Proceeding with current remote." | tee -a "$BRAIN_DIR/logs/sync_fail.log"
fi

echo "Starting brain sync for $HOSTNAME..."

# --- Change to Brain Directory ---
cd "$BRAIN_DIR" || { echo "Error: Could not change directory to $BRAIN_DIR." | tee -a "$BRAIN_DIR/logs/sync_fail.log"; exit 1; }

# --- Step 1: SYNC latest changes ---
echo "Pulling latest changes from origin/$MAIN_BRANCH..."
git pull --rebase origin "$MAIN_BRANCH"
if [ $? -ne 0 ]; then
    echo "Warning: Git pull --rebase failed. Attempting to continue with current state." | tee -a "$BRAIN_DIR/logs/sync_fail.log"
fi

# --- Step 2: Stage learned files ---
echo "Staging learned files..."
# Check if there are any modified/new files in the learned directory to stage
# Use git status --porcelain for scriptable output
if ! git status --porcelain "$LEARNED_DIR" | grep -q '^[AM]'; then
    echo "No new or modified learned files to stage. Skipping commit and PR."
    exit 0
else
    git add "$LEARNED_DIR/"
fi

# --- Step 3: COMMIT ---
COMMIT_MESSAGE="brain: learnings from $(hostname) - $(date +%Y-%m-%d)"
echo "Committing changes with message: "$COMMIT_MESSAGE""
git commit -m "$COMMIT_MESSAGE"

# --- Step 4: PUSH ---
echo "Pushing to origin/$BRANCH_NAME..."
# Check if branch exists locally before trying to push
if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    echo "Creating new branch '$BRANCH_NAME'..."
    git checkout -b "$BRANCH_NAME"
else
    echo "Branch '$BRANCH_NAME' already exists locally. Checking out..."
    git checkout "$BRANCH_NAME"
fi
git push --set-upstream origin "$BRANCH_NAME"
if [ $? -ne 0 ]; then
    echo "Error: Git push failed. Please check your network and permissions." | tee -a "$BRAIN_DIR/logs/sync_fail.log"
    # Attempt to clean up branch if push fails
    git checkout "$MAIN_BRANCH"
    git branch -D "$BRANCH_NAME"
    exit 1
fi

# --- Step 5: CREATE and MERGE PR ---
echo "Creating pull request..."
# Check if a PR for this branch already exists and is open
# --state open,draft,closed --json number,state will give us all PRs
# We need to find one that is NOT merged.
PR_NUMBER=$(gh pr list --base "$MAIN_BRANCH" --head "$BRANCH_NAME" --json number,state --jq 'map(select(.state != "MERGED")) | .[0].number')

if [ -n "$PR_NUMBER" ] && [ "$PR_NUMBER" != "null" ]; then
    echo "PR for branch '$BRANCH_NAME' already exists (PR #$PR_NUMBER). Attempting to merge it."
else
    echo "Creating new PR..."
    PR_OUTPUT=$(gh pr create --title "$PR_TITLE" --body "$PR_BODY" --base "$MAIN_BRANCH" --head "$BRANCH_NAME" --json number)
    PR_NUMBER=$(echo "$PR_OUTPUT" | jq -r '.number')
    if [ -z "$PR_NUMBER" ] || [ "$PR_NUMBER" == "null" ]; then
        echo "Error: Failed to create pull request. Output: $PR_OUTPUT" | tee -a "$BRAIN_DIR/logs/sync_fail.log"
        # Clean up branch on PR creation failure
        git checkout "$MAIN_BRANCH"
        git branch -D "$BRANCH_NAME"
        exit 1
    fi
    echo "PR created successfully: #$PR_NUMBER"
fi

echo "Attempting to auto-merge PR #$PR_NUMBER..."
# Use --auto and --merge. GitHub CLI handles the validation workflow check.
gh pr merge --auto --merge "$PR_NUMBER"
if [ $? -ne 0 ]; then
    echo "Warning: Auto-merge failed or is pending for PR #$PR_NUMBER. It might be waiting for GitHub Actions to pass." | tee -a "$BRAIN_DIR/logs/sync_fail.log"
    echo "Please check the PR status at: https://github.com/unclehowell/unclehowell/pull/$PR_NUMBER"
else
    echo "PR #$PR_NUMBER auto-merge requested. It will merge once validations pass."
fi

# --- Clean up local branch ---
echo "Cleaning up local branch '$BRANCH_NAME'..."
git checkout "$MAIN_BRANCH"
git branch -d "$BRANCH_NAME"

echo "Brain sync script finished."
exit 0

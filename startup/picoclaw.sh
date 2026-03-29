#!/bin/bash
# Picoclaw brain integration
# This runs before/after picoclaw operations

BRAIN_DIR="/home/unclehowell/brain"

# On startup - pull brain
pull_brain() {
    cd "$BRAIN_DIR"
    git fetch origin
    git reset --hard origin/main 2>/dev/null
}

pull_brain

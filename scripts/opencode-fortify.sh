#!/bin/bash
# OpenCode Brain Fortification - Run this to make OpenCode always use the brain
# Add to ~/.bashrc or run before starting opencode

BRAIN_DIR="${BRAIN_DIR:-/home/unclehowell/brain}"

# Read AGENTS.md on each invocation (exported as env var for the session)
export OPENCODE_SYSTEM_PROMPT_FILE="$BRAIN_DIR/AGENTS.md"

# Create a wrapper that sources brain and reads AGENTS.md
alias opencode='OPENCODE_SYSTEM_PROMPT_FILE="$BRAIN_DIR/AGENTS.md" opencode'

echo "🧠 OpenCode fortified with brain: $BRAIN_DIR"
echo "   AGENTS.md will be loaded at startup"

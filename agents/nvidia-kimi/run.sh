#!/bin/bash
# Quick launcher for NVIDIA Kimi agent

AGENT_DIR="$HOME/brain/agents/nvidia-kimi"
export NVAPI_KEY="${NVAPI_KEY:-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}"

"$AGENT_DIR/agent.sh" "$@"

#!/bin/bash
# Quick launcher for NVIDIA Kimi agent

AGENT_DIR="$HOME/brain/agents/nvidia-kimi"
export NVAPI_KEY="${NVAPI_KEY:-${NVIDIA_API_KEY}}"

"$AGENT_DIR/agent.sh" "$@"

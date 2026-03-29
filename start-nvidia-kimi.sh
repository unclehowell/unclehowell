#!/bin/bash
# Start NVIDIA Kimi Idle Monitor as background service

BRAIN_DIR="$HOME/brain"
AGENT_DIR="$BRAIN_DIR/agents/nvidia-kimi"

# Check if already running
if pm2 list | grep -q "nvidia-kimi-monitor"; then
    echo "NVIDIA Kimi Monitor already running"
    pm2 logs nvidia-kimi-monitor --lines 10 --nostream
    exit 0
fi

# Set API key
export NVAPI_KEY="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"

# Start via PM2
cd "$AGENT_DIR"
pm2 start "$HOME/nvidia-kimi-pm2.ecosystem.js"

echo "NVIDIA Kimi Monitor started"
pm2 logs nvidia-kimi-monitor --lines 5 --nostream

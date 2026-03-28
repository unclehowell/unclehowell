#!/bin/bash
# Test PCP2 form using Browserbase

export BROWSERBASE_API_KEY="bb_live_ItbGTPuCy-hACNB-BGOZWjy-1fk"
export PROJECT_ID="2d1dd715-cebe-4ed5-ab24-00e66bb276e7"

echo "=== Browserbase Browser Test ==="
echo "Timestamp: $(date -Iseconds)"

# Create a session
echo "Creating browser session..."
SESSION=$(curl -s -X POST "https://api.browserbase.com/v1/sessions" \
  -H "Content-Type: application/json" \
  -H "X-BB-API-Key: $BROWSERBASE_API_KEY" \
  -d "{\"projectId\": \"$PROJECT_ID\"}")

echo "Session response: $SESSION"

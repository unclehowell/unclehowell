#!/bin/bash
# Trial & Error Tinker - Universal Debug Harness
# Usage: tinker.sh --target <path> --criteria <condition> [--max-iterations N]

set -eo pipefail

TARGET=""
CRITERIA=""
MAX_ITERATIONS=20
ITERATION=0
LOG_FILE="/tmp/tinker-$(date +%s).log"

usage() {
    echo "Usage: $0 --target <path> --criteria <condition> [--max-iterations N]"
    echo "  --target        Project directory to tinker on"
    echo "  --criteria      Success criteria (e.g., 'HTTP 200', 'exit 0')"
    echo "  --max-iterations  Max loops before pause (default: 20)"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --target) TARGET="$2"; shift 2 ;;
        --criteria) CRITERIA="$2"; shift 2 ;;
        --max-iterations) MAX_ITERATIONS="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) echo "Unknown: $1"; usage ;;
    esac
done

[ -z "$TARGET" ] || [ -z "$CRITERIA" ] && usage

echo "🎛️  TINKER HARNESS"
echo "Target: $TARGET"
echo "Criteria: $CRITERIA"
echo "Max iterations: $MAX_ITERATIONS"
echo "Log: $LOG_FILE"
echo "---"

while [ $ITERATION -lt $MAX_ITERATIONS ]; do
    ITERATION=$((ITERATION + 1))
    echo "[ITERATION $ITERATION/$MAX_ITERATIONS]"
    
    echo "1. Analyzing state..."
    # Placeholder: extend with actual analysis
    
    echo "2. Hypothesizing fix..."
    # Placeholder: user or LLM provides the fix
    
    echo "3. Awaiting user input for this iteration..."
    echo "   (Use opencode/picoclaw/claude to apply fixes)"
    
    echo "4. Testing against criteria: $CRITERIA"
    # Placeholder: implement actual test
    
    echo "5. Log result"
    echo "[$(date)] Iteration $ITERATION" >> "$LOG_FILE"
    
    read -p "Did the test pass? (y/n): " PASSED
    if [ "$PASSED" = "y" ]; then
        echo "✅ SUCCESS! Tinkering complete."
        exit 0
    fi
    
    echo "❌ Failed. Looping..."
    echo "---"
done

echo "⚠️  Reached max iterations ($MAX_ITERATIONS). Manual review needed."
echo "Log: $LOG_FILE"
exit 1

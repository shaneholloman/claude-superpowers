#!/bin/bash
#
# ralph-loop.sh - Autonomous Claude Code development loop
# 
# A working alternative to the broken ralph-wiggum plugin.
# See README.md for documentation.
#
# Usage: ./ralph-loop.sh [max_iterations]
# Default: 50 iterations

MAX_ITERATIONS=${1:-50}
ITERATION=0
PROMPT_FILE=".claude/RALPH_PROMPT.md"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           RALPH LOOP - Autonomous Development             ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Max iterations: $MAX_ITERATIONS"
echo "Prompt file: $PROMPT_FILE"
echo "Press Ctrl+C to stop"
echo ""

# Check prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "ERROR: $PROMPT_FILE not found!"
    echo ""
    echo "Create your prompt file at $PROMPT_FILE"
    echo "See PROMPT_TEMPLATE.md for an example."
    exit 1
fi

# Main loop
while [ $ITERATION -lt $MAX_ITERATIONS ]; do
    ITERATION=$((ITERATION + 1))
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  ITERATION $ITERATION / $MAX_ITERATIONS  -  $(date +%H:%M:%S)"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    
    # Run Claude with the prompt
    OUTPUT=$(claude -p --dangerously-skip-permissions "$(cat $PROMPT_FILE)" 2>&1)
    echo "$OUTPUT"
    
    # Check for completion promise (customize this for your task)
    if echo "$OUTPUT" | grep -q "<promise>.*</promise>"; then
        PROMISE=$(echo "$OUTPUT" | grep -o "<promise>.*</promise>" | head -1)
        echo ""
        echo "═══════════════════════════════════════════════════════════"
        echo "  ✓ COMPLETION PROMISE DETECTED: $PROMISE"
        echo "  Loop finished after $ITERATION iterations"
        echo "═══════════════════════════════════════════════════════════"
        exit 0
    fi
    
    # Safety check - stop if prompt file gets deleted
    if [ ! -f "$PROMPT_FILE" ]; then
        echo ""
        echo "ERROR: Prompt file was deleted! Stopping."
        echo "Move your prompt to .claude/ directory to prevent this."
        exit 1
    fi
done

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Max iterations ($MAX_ITERATIONS) reached"
echo "  Loop stopped without completion promise"
echo "═══════════════════════════════════════════════════════════"
exit 1

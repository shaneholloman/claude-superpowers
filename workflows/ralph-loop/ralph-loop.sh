#!/bin/bash
#
# ralph-loop.sh - Autonomous Claude Code development loop
# 
# A working alternative to the broken ralph-wiggum plugin.
# Includes timing stats and CLAUDE.md integration.
#
# Usage: ./ralph-loop.sh [max_iterations]
# Default: 50 iterations

MAX_ITERATIONS=${1:-50}
ITERATION=0
PROMPT_FILE=".claude/RALPH_PROMPT.md"
CLAUDE_MD="CLAUDE.md"
START_TIME=$(date +%s)

# Function to format seconds as HH:MM:SS
format_time() {
    local total_seconds=$1
    local hours=$((total_seconds / 3600))
    local minutes=$(( (total_seconds % 3600) / 60 ))
    local seconds=$((total_seconds % 60))
    printf "%02d:%02d:%02d" $hours $minutes $seconds
}

# Function to display stats
show_stats() {
    local current_time=$(date +%s)
    local elapsed=$((current_time - START_TIME))
    local elapsed_formatted=$(format_time $elapsed)
    
    if [ $ITERATION -gt 0 ]; then
        local avg_per_iteration=$((elapsed / ITERATION))
        local remaining_iterations=$((MAX_ITERATIONS - ITERATION))
        local estimated_remaining=$((avg_per_iteration * remaining_iterations))
        local estimated_formatted=$(format_time $estimated_remaining)
        local total_estimated=$((elapsed + estimated_remaining))
        local total_formatted=$(format_time $total_estimated)
        
        echo "├─ Elapsed: $elapsed_formatted"
        echo "├─ Avg per iteration: $(format_time $avg_per_iteration)"
        echo "├─ Est. remaining: $estimated_formatted"
        echo "└─ Est. total: $total_formatted"
    else
        echo "└─ Elapsed: $elapsed_formatted"
    fi
}

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           RALPH LOOP - Autonomous Development             ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Max iterations: $MAX_ITERATIONS"
echo "Prompt file: $PROMPT_FILE"
echo "CLAUDE.md: $([ -f "$CLAUDE_MD" ] && echo "Found ✓" || echo "Not found")"
echo "Started at: $(date '+%Y-%m-%d %H:%M:%S')"
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

# Build the full prompt (CLAUDE.md + RALPH_PROMPT.md)
build_prompt() {
    local full_prompt=""
    
    # Include CLAUDE.md if it exists
    if [ -f "$CLAUDE_MD" ]; then
        full_prompt+="## Project Context (from CLAUDE.md)

$(cat $CLAUDE_MD)

---

"
    fi
    
    # Add the main prompt
    full_prompt+="$(cat $PROMPT_FILE)"
    
    echo "$full_prompt"
}

# Main loop
while [ $ITERATION -lt $MAX_ITERATIONS ]; do
    ITERATION=$((ITERATION + 1))
    ITER_START=$(date +%s)
    
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  ITERATION $ITERATION / $MAX_ITERATIONS  •  $(date '+%H:%M:%S')"
    echo "───────────────────────────────────────────────────────────"
    show_stats
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    
    # Run Claude with the combined prompt
    FULL_PROMPT=$(build_prompt)
    OUTPUT=$(claude -p --dangerously-skip-permissions "$FULL_PROMPT" 2>&1)
    echo "$OUTPUT"
    
    # Calculate iteration time
    ITER_END=$(date +%s)
    ITER_DURATION=$((ITER_END - ITER_START))
    echo ""
    echo "───────────────────────────────────────────────────────────"
    echo "  Iteration $ITERATION completed in $(format_time $ITER_DURATION)"
    echo "───────────────────────────────────────────────────────────"
    
    # Check for completion promise
    if echo "$OUTPUT" | grep -q "<promise>.*</promise>"; then
        PROMISE=$(echo "$OUTPUT" | grep -o "<promise>.*</promise>" | head -1)
        TOTAL_TIME=$(($(date +%s) - START_TIME))
        echo ""
        echo "╔═══════════════════════════════════════════════════════════╗"
        echo "║  ✓ COMPLETION PROMISE DETECTED                            ║"
        echo "╠═══════════════════════════════════════════════════════════╣"
        echo "  Promise: $PROMISE"
        echo "  Iterations: $ITERATION"
        echo "  Total time: $(format_time $TOTAL_TIME)"
        echo "╚═══════════════════════════════════════════════════════════╝"
        exit 0
    fi
    
    # Safety check
    if [ ! -f "$PROMPT_FILE" ]; then
        echo "ERROR: Prompt file was deleted! Stopping."
        exit 1
    fi
done

TOTAL_TIME=$(($(date +%s) - START_TIME))
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  Max iterations ($MAX_ITERATIONS) reached                           ║"
echo "╠═══════════════════════════════════════════════════════════╣"
echo "  Total time: $(format_time $TOTAL_TIME)"
echo "  Avg per iteration: $(format_time $((TOTAL_TIME / MAX_ITERATIONS)))"
echo "╚═══════════════════════════════════════════════════════════╝"
exit 1

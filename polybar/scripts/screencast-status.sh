#!/usr/bin/env bash
# Screencast recording status indicator for polybar
# Shows recording indicator when screencast is active

RECORDING_FILE="/tmp/i3-screencast-recording"

# Check if recording file exists and process is active
if [ -f "$RECORDING_FILE" ]; then
    PID=$(cat "$RECORDING_FILE" 2>/dev/null)
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        # Recording is active - show indicator
        echo "󰑬 REC"
        exit 0
    else
        # PID file exists but process is dead, clean it up
        rm -f "$RECORDING_FILE" 2>/dev/null
    fi
fi

# Not recording - output empty string (polybar will hide the module)
echo ""


#!/usr/bin/env bash

# ============================================
# Polybar Launch Script
# Kills existing Polybar instances and launches a new one
# ============================================

# Kill any existing polybar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do
    sleep 1
done

# Launch Polybar on primary monitor only
# If you want it on all monitors, uncomment the loop below and comment this line
if type "xrandr" > /dev/null; then
    # Get primary monitor
    PRIMARY=$(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1)
    if [ -z "$PRIMARY" ]; then
        # If no primary is set, use the first connected monitor
        PRIMARY=$(xrandr --query | grep " connected" | cut -d" " -f1 | head -n1)
    fi
    MONITOR=$PRIMARY polybar main &
else
    # Fallback if xrandr is not available
    polybar main &
fi

# Alternative: Launch on all monitors (uncomment to use)
# if type "xrandr" > /dev/null; then
#     for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#         MONITOR=$m polybar main &
#     done
# else
#     polybar main &
# fi

echo "Polybar launched successfully!"


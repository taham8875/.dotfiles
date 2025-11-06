#!/usr/bin/env bash
# Get volume status for display
if command -v pactl &> /dev/null; then
    # Get mute status
    MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -oE 'yes|no')
    VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | sed 's/%//')
    
    if [ "$MUTED" = "yes" ]; then
        echo "󰝟"
    else
        echo "󰕾  ${VOLUME}%"
    fi
else
    echo "󰕾"
fi






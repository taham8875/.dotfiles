#!/usr/bin/env bash
# Microphone volume control script for polybar
# Shows current mic input volume percentage

# Get default source (microphone)
SOURCE=$(pactl get-default-source)

# Get volume percentage
VOLUME=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP '\d+%' | head -1 | sed 's/%//')

# Check if muted
MUTED=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [ "$MUTED" = "yes" ]; then
    echo "󰍭 muted"
else
    echo "󰍬  ${VOLUME}%"
fi















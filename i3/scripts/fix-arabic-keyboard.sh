#!/usr/bin/env bash
# Quick fix script for Arabic keyboard layout

# Force set the layout
setxkbmap -layout us,ara -option grp:alt_shift_toggle

# Verify
if setxkbmap -query | grep -q "ara"; then
    notify-send "Arabic Keyboard" "Layout enabled - Alt+Shift to toggle" 2>/dev/null
    echo "✅ Arabic keyboard enabled"
    setxkbmap -query
else
    notify-send "Arabic Keyboard" "Failed to enable. Run: Mod+Shift+b to retry" 2>/dev/null
    echo "❌ Failed to enable Arabic keyboard"
fi




#!/usr/bin/env bash
# Setup Arabic keyboard layout switching with Alt+Shift

# Wait for X to be ready
sleep 1.5

# Check available layouts (Arabic is usually "ara" on Ubuntu)
ARABIC_LAYOUT=""
if [ -f /usr/share/X11/xkb/symbols/ara ]; then
    ARABIC_LAYOUT="ara"
elif [ -f /usr/share/X11/xkb/symbols/ar ]; then
    ARABIC_LAYOUT="ar"
fi

if [ -n "$ARABIC_LAYOUT" ]; then
    # Set keyboard layouts: English (us) and Arabic
    # Alt+Shift will toggle between them
    setxkbmap -layout us,$ARABIC_LAYOUT -option grp:alt_shift_toggle
    
    # Verify the setting
    if setxkbmap -query | grep -q "$ARABIC_LAYOUT"; then
        echo "✓ Arabic keyboard enabled: Alt+Shift to switch" >> /tmp/i3-arabic-setup.log
        notify-send "Arabic Keyboard" "Enabled - Alt+Shift to switch" 2>/dev/null || true
    else
        echo "✗ Failed to set Arabic layout" >> /tmp/i3-arabic-setup.log
    fi
    
    # Re-apply after a delay to ensure it persists (in case IBus or other services reset it)
    (
        sleep 3
        setxkbmap -layout us,$ARABIC_LAYOUT -option grp:alt_shift_toggle
        echo "✓ Re-applied keyboard layout after delay" >> /tmp/i3-arabic-setup.log
    ) &
else
    echo "Arabic layout not found. Installing..." >> /tmp/i3-arabic-setup.log
    notify-send "Arabic Keyboard" "Layout not installed. Run: sudo apt install keyboard-configuration" 2>/dev/null || true
    
    # Still set English with toggle ready
    setxkbmap -layout us -option grp:alt_shift_toggle
fi

# Display current layout
setxkbmap -query >> /tmp/i3-arabic-setup.log 2>&1


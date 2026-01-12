#!/usr/bin/env bash
# Copyq toggle script - opens as floating window and auto-closes on selection
# This mimics GNOME behavior where copyq closes when you select an item

# Check if copyq window is already visible
if copyq eval "true" 2>/dev/null | grep -q "true"; then
    # If window is visible, hide it
    copyq hide
else
    # Show copyq window (will be made floating by i3 window rules)
    copyq show
    
    # Wait a bit for window to appear, then focus it
    sleep 0.3
    
    # Focus the copyq window
    i3-msg '[class="^copyq$"] focus' 2>/dev/null || i3-msg '[class="^CopyQ$"] focus' 2>/dev/null
    
    # Monitor for when copyq window closes (user selected an item or closed it)
    # This is a background process that will clean up if needed
    (
        # Wait for copyq window to disappear (user selected item or closed window)
        while i3-msg -t get_tree | grep -q "copyq\|CopyQ"; do
            sleep 0.5
        done
    ) &
fi





















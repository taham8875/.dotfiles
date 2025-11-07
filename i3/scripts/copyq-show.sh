#!/usr/bin/env bash
# Copyq show script - opens as small floating window and auto-closes on selection

# Toggle copyq window (show if hidden, hide if shown)
copyq toggle

# If window is now visible, wait for it to close (user selected item or closed it)
# The activate_closes setting should handle closing, but we monitor as backup
if copyq eval "true" 2>/dev/null | grep -q "true"; then
    # Window is visible, monitor for when it closes
    # This is a background process that ensures cleanup
    (
        # Wait up to 30 seconds for window to close
        for i in {1..60}; do
            sleep 0.5
            # Check if copyq window still exists
            if ! i3-msg -t get_tree | grep -qi "copyq"; then
                # Window closed, exit
                exit 0
            fi
        done
    ) &
fi









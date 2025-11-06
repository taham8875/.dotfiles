#!/usr/bin/env bash
# Copyq auto-close script - monitors clipboard and closes copyq when item is selected

# Show copyq window
copyq show

# Get initial clipboard content to detect changes
INITIAL_CLIP=$(copyq clipboard 2>/dev/null)

# Wait for clipboard to change (user selected an item)
for i in {1..20}; do
    sleep 0.1
    CURRENT_CLIP=$(copyq clipboard 2>/dev/null)
    
    # If clipboard changed, user selected an item - close copyq
    if [ "$CURRENT_CLIP" != "$INITIAL_CLIP" ] && [ -n "$CURRENT_CLIP" ]; then
        copyq hide
        exit 0
    fi
    
    # Also check if copyq window still exists (user might have closed it manually)
    if ! i3-msg -t get_tree | grep -qi "copyq"; then
        # Window already closed
        exit 0
    fi
done

# If we get here, clipboard didn't change - user might have clicked away
# The close_on_unfocus setting should handle this, but we'll close it anyway after a delay
sleep 0.5
copyq hide


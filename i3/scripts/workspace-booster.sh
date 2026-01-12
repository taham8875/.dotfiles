#!/bin/bash
# Workspace Booster Script
# Automatically opens all applications in their designated workspaces
# This rebuilds your workspace layout with one command

# Wait function to ensure applications launch properly
wait_a_bit() {
    sleep 0.5
}

# Workspace 1: Terminal
i3-msg 'workspace number 1; exec konsole'
wait_a_bit

# Workspace 4: MS Edge (first instance)
i3-msg 'workspace number 4; exec microsoft-edge'
wait_a_bit

# Workspace 5: MS Edge (second instance)
i3-msg 'workspace number 5; exec microsoft-edge'
wait_a_bit

# Workspace 6: MS Edge (third instance)
i3-msg 'workspace number 6; exec microsoft-edge'
wait_a_bit

# Workspace 7: Chrome
i3-msg 'workspace number 7; exec google-chrome'
wait_a_bit

# Workspace 9: Terminal with tmux
i3-msg 'workspace number 9; exec konsole -e tmux'
wait_a_bit

# Return to workspace 1 as default
i3-msg 'workspace number 1'

# Send notification
notify-send "Workspace Booster" "All workspaces initialized!" -i dialog-information







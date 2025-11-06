#!/usr/bin/env bash
# Setup Arabic keyboard and input method support

# Set up keyboard layouts (English + Arabic)
# Switch between layouts with Alt+Shift (default) or set custom keybinding

# Wait a moment for X to be ready
sleep 0.5

# Set keyboard layout with toggle option
# Use Alt+Shift to toggle between English (us) and Arabic (ar)
if setxkbmap -layout us,ar -option grp:alt_shift_toggle 2>/dev/null; then
    echo "Keyboard layout set: English + Arabic (Alt+Shift to toggle)"
else
    # Fallback: try with different layout names
    if setxkbmap -layout us,ara -option grp:alt_shift_toggle 2>/dev/null; then
        echo "Keyboard layout set: English + Arabic (ara variant)"
    else
        # If Arabic layout not available, install it or use alternative
        echo "Warning: Arabic layout may not be installed. Install with: sudo apt install keyboard-configuration"
        # Still set English as fallback
        setxkbmap -layout us -option grp:alt_shift_toggle 2>/dev/null
    fi
fi

# Alternative: Use Ctrl+Space to switch between layouts
# setxkbmap -layout us,ar -option grp:ctrl_space_toggle

# Start IBus for Arabic input (if installed)
# Note: IBus can interfere with setxkbmap, so we configure it to not override keyboard layouts
if command -v ibus &> /dev/null; then
    export GTK_IM_MODULE=ibus
    export QT_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    # Start IBus but don't let it manage keyboard layouts
    ibus-daemon -drx --xim &
    # Wait a bit then re-apply keyboard layout to ensure it persists
    sleep 2
    setxkbmap -layout us,ara -option grp:alt_shift_toggle 2>/dev/null || setxkbmap -layout us,ar -option grp:alt_shift_toggle 2>/dev/null
fi

# Start fcitx5 for Arabic input (if installed, alternative to IBus)
if command -v fcitx5 &> /dev/null && ! pgrep -x fcitx5 > /dev/null; then
    export GTK_IM_MODULE=fcitx5
    export QT_IM_MODULE=fcitx5
    export XMODIFIERS=@im=fcitx5
    fcitx5 &
fi

echo "Arabic support configured"



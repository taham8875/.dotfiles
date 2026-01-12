#!/usr/bin/env bash
# Configure idle behavior - keep computer running, lock after 4 hours

# 4 hours in seconds = 14400
IDLE_TIMEOUT=14400

# Configure DPMS (Display Power Management Signaling)
# Format: xset dpms standby suspend off
# This sets very long timeouts (4 hours) before screen powers off
xset +dpms
xset dpms 0 0 $IDLE_TIMEOUT

# Configure screensaver (blank screen after 4 hours)
xset s $IDLE_TIMEOUT $IDLE_TIMEOUT

# Disable screensaver blanking (optional - uncomment if you want screen to never blank)
# xset s off
# xset s noblank

# Configure systemd-logind to not lock on idle (if available)
if command -v loginctl &> /dev/null; then
    # Set idle action to none (do nothing)
    loginctl set-user-property $(whoami) IdleAction none 2>/dev/null || true
    loginctl set-user-property $(whoami) IdleActionUSec 0 2>/dev/null || true
fi

# Log the configuration
echo "$(date): Idle lock configured - will lock after $IDLE_TIMEOUT seconds (4 hours)" >> /tmp/i3-idle-config.log


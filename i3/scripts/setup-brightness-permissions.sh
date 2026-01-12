#!/usr/bin/env bash
# Setup brightness control permissions
# This script configures udev rules to allow brightness control without sudo

BACKLIGHT_DIR="/sys/class/backlight/intel_backlight"
UDEV_RULE="/etc/udev/rules.d/90-backlight.rules"

echo "Setting up brightness control permissions..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "This script needs to be run with sudo."
    echo "Please run: sudo $0"
    exit 1
fi

# Create udev rule to allow video group to control brightness
cat > "$UDEV_RULE" << 'EOF'
# Allow users in video group to control backlight brightness
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="*", RUN+="/bin/chmod 666 /sys/class/backlight/%k/brightness /sys/class/backlight/%k/max_brightness"
EOF

# Reload udev rules
udevadm control --reload-rules
udevadm trigger --subsystem-match=backlight

echo ""
echo "✓ Brightness permissions configured!"
echo ""
echo "Note: You may need to:"
echo "  1. Log out and log back in (or restart)"
echo "  2. Or manually run: sudo chmod 666 $BACKLIGHT_DIR/brightness $BACKLIGHT_DIR/max_brightness"
echo ""
echo "After that, brightness controls should work without sudo."






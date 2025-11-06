#!/usr/bin/env bash
# Setup 118% display scaling (like Windows/GNOME accessibility settings)
# This sets DPI and environment variables for GTK/Qt/Electron applications

# Set X11 DPI to 113 (118% of default 96 DPI)
# 96 * 1.18 = 113.28, rounded to 113
xrandr --dpi 113 2>/dev/null || true

# Set GTK scaling (for GTK applications like Nautilus, Gedit, etc.)
export GDK_SCALE=1.18
export GDK_DPI_SCALE=1.0

# Set Qt scaling (for Qt applications like Konsole, etc.)
export QT_SCALE_FACTOR=1.18
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Set Electron scaling (for Microsoft Edge, VS Code, Discord, etc.)
export ELECTRON_SCALE_FACTOR=1.18

# Make these persistent by adding to shell profile
# Check if already added to avoid duplicates
if ! grep -q "GDK_SCALE=1.18" ~/.profile 2>/dev/null; then
    cat >> ~/.profile << 'EOF'

# 118% Display Scaling (set by i3 setup script)
export GDK_SCALE=1.18
export GDK_DPI_SCALE=1.0
export QT_SCALE_FACTOR=1.18
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export ELECTRON_SCALE_FACTOR=1.18
EOF
fi

# Also set for current session
export GDK_SCALE=1.18
export GDK_DPI_SCALE=1.0
export QT_SCALE_FACTOR=1.18
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export ELECTRON_SCALE_FACTOR=1.18



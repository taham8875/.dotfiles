#!/usr/bin/env bash
# Enable dark mode for GTK applications (Nemo, Gedit, etc.)

# Modern way (GNOME 42+): Set color scheme preference
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

# Set GTK3 theme
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true

# Set GTK4 theme (for modern Nautilus and other GTK4 apps)
# Handle symlinks by resolving to actual target
GTK4_DIR="$HOME/.config/gtk-4.0"
if [ -L "$GTK4_DIR" ]; then
    GTK4_DIR=$(readlink -f "$GTK4_DIR" 2>/dev/null || echo "$HOME/.dotfiles/gtk-4.0")
fi
mkdir -p "$GTK4_DIR"
{
    echo "[Settings]"
    echo "gtk-theme-name=Adwaita-dark"
    echo "gtk-application-prefer-dark-theme=true"
} > "$GTK4_DIR/settings.ini"

# Also set GTK3 settings file
GTK3_DIR="$HOME/.config/gtk-3.0"
if [ -L "$GTK3_DIR" ]; then
    GTK3_DIR=$(readlink -f "$GTK3_DIR" 2>/dev/null || echo "$HOME/.dotfiles/gtk-3.0")
fi
mkdir -p "$GTK3_DIR"
{
    echo "[Settings]"
    echo "gtk-theme-name=Adwaita-dark"
    echo "gtk-application-prefer-dark-theme=true"
} > "$GTK3_DIR/settings.ini"

# Set environment variables (for apps launched from i3)
export GTK_THEME="Adwaita-dark"
export GTK_THEME_NAME="Adwaita-dark"

# For Nemo specifically (if needed)
# Nemo respects GTK theme settings automatically


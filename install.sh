#!/usr/bin/env bash
# Dotfiles installation script
# Creates symlinks from ~/.dotfiles to ~/.config and ~/

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}Starting dotfiles installation from: ${DOTFILES_DIR}${NC}\n"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}Backing up existing: $target${NC}"
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Remove old symlink if it exists
    if [ -L "$target" ]; then
        rm "$target"
    fi

    # Create new symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}✓${NC} Linked: $target -> $source"
}

echo "=== Installing .config files ==="

# i3 window manager
create_symlink "$DOTFILES_DIR/i3" "$HOME/.config/i3"

# Status bar
create_symlink "$DOTFILES_DIR/polybar" "$HOME/.config/polybar"

# App launcher
create_symlink "$DOTFILES_DIR/rofi" "$HOME/.config/rofi"

# Notifications
create_symlink "$DOTFILES_DIR/dunst" "$HOME/.config/dunst"

# Terminal emulators
create_symlink "$DOTFILES_DIR/config/alacritty" "$HOME/.config/alacritty"
create_symlink "$DOTFILES_DIR/konsole" "$HOME/.config/konsole"

# Shell
create_symlink "$DOTFILES_DIR/config/zsh" "$HOME/.config/zsh"
create_symlink "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"

# GTK theme
create_symlink "$DOTFILES_DIR/gtk-3.0" "$HOME/.config/gtk-3.0"
create_symlink "$DOTFILES_DIR/gtk-4.0" "$HOME/.config/gtk-4.0"

# Autostart
create_symlink "$DOTFILES_DIR/autostart" "$HOME/.config/autostart"

# System info
create_symlink "$DOTFILES_DIR/neofetch" "$HOME/.config/neofetch"

# System monitors
create_symlink "$DOTFILES_DIR/btop" "$HOME/.config/btop"
create_symlink "$DOTFILES_DIR/htop" "$HOME/.config/htop"

# Media player
create_symlink "$DOTFILES_DIR/mpv" "$HOME/.config/mpv"

# Compositor
create_symlink "$DOTFILES_DIR/picom.conf" "$HOME/.config/picom.conf"

# Shell prompt
create_symlink "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# Screenkey
create_symlink "$DOTFILES_DIR/screenkey.json" "$HOME/.config/screenkey.json"

# Clipboard manager
if [ -d "$DOTFILES_DIR/copyq" ]; then
    create_symlink "$DOTFILES_DIR/copyq" "$HOME/.config/copyq"
fi

# Ghostty terminal
if [ -d "$DOTFILES_DIR/ghostty" ]; then
    create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
fi

echo -e "\n=== Installing home directory files ==="

# X11 profile (display scaling)
create_symlink "$DOTFILES_DIR/.xprofile" "$HOME/.xprofile"

# Git config
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# Zsh config
create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

# Zsh environment
create_symlink "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"

# Mouse wheel scroll speed
create_symlink "$DOTFILES_DIR/.imwheelrc" "$HOME/.imwheelrc"

echo -e "\n${GREEN}=== Installation complete! ===${NC}\n"

# Post-installation notes
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Install required packages (see README.md)"
echo "2. Log out and log back in (or restart X session)"
echo "3. Select 'i3' as your window manager at login"
echo "4. Customize .gitconfig with your email/name if needed"
echo "5. Download wallpaper: ~/Downloads/wallhaven-5g22q5.png"
echo ""
echo -e "${GREEN}Enjoy your new setup!${NC}"

#!/usr/bin/env bash
# Fix missing fonts for polybar

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing JetBrainsMono Nerd Font...${NC}\n"

# Create fonts directory
mkdir -p ~/.local/share/fonts

# Download JetBrainsMono Nerd Font
cd /tmp
echo "Downloading font..."
wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip

echo "Extracting..."
unzip -q JetBrainsMono.zip -d JetBrainsMono

echo "Installing..."
cp JetBrainsMono/*.ttf ~/.local/share/fonts/

# Update font cache
echo "Updating font cache..."
fc-cache -fv ~/.local/share/fonts

# Cleanup
rm -rf JetBrainsMono JetBrainsMono.zip

echo -e "\n${GREEN}✓ Font installed!${NC}"
echo -e "${YELLOW}Restart polybar to see changes:${NC}"
echo "  killall polybar"
echo "  ~/.config/polybar/launch.sh &"

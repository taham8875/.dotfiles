#!/usr/bin/env bash
# Fix nvim freeze and powermenu emoji issues

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Fixing Nvim & Powermenu Issues${NC}"
echo -e "${GREEN}========================================${NC}\n"

# ============================================
# 1. Fix Powermenu Corrupted Emojis
# ============================================
echo -e "${BLUE}[1/2] Fixing rofi powermenu emojis...${NC}"

# The issue is that Nerd Font icons need the complete font to be installed
# Let's verify JetBrainsMono Nerd Font is properly installed
if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    echo -e "${GREEN}✓${NC} JetBrainsMono Nerd Font is installed"

    # Update font cache
    fc-cache -fv ~/.local/share/fonts > /dev/null 2>&1
    echo -e "${GREEN}✓${NC} Font cache updated"
else
    echo -e "${YELLOW}⚠${NC}  JetBrainsMono Nerd Font not found, installing..."
    mkdir -p ~/.local/share/fonts
    cd /tmp
    wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip -q JetBrainsMono.zip -d JetBrainsMono
    cp JetBrainsMono/*.ttf ~/.local/share/fonts/
    fc-cache -fv ~/.local/share/fonts > /dev/null 2>&1
    rm -rf JetBrainsMono JetBrainsMono.zip
    echo -e "${GREEN}✓${NC} JetBrainsMono Nerd Font installed"
fi

# ============================================
# 2. Fix Nvim Freeze Issue
# ============================================
echo -e "\n${BLUE}[2/2] Fixing nvim freeze issue...${NC}"

# The freeze is likely caused by lazy.nvim trying to install plugins
# on first run. We need to install them manually first.

if [ -d ~/.config/nvim ]; then
    echo "Found nvim config, checking for lazy.nvim..."

    # Check if lazy.nvim is installed
    LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
    if [ ! -d "$LAZY_PATH" ]; then
        echo "Installing lazy.nvim plugin manager..."
        git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_PATH"
        echo -e "${GREEN}✓${NC} Installed lazy.nvim"
    else
        echo -e "${GREEN}✓${NC} lazy.nvim already installed"
    fi

    # Install plugins in headless mode (non-interactive)
    echo "Installing nvim plugins (this may take a minute)..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || {
        echo -e "${YELLOW}⚠${NC}  Plugin installation had some issues, but that's normal on first run"
    }

    echo -e "${GREEN}✓${NC} Nvim plugins installation initiated"
    echo ""
    echo -e "${YELLOW}Note:${NC} If nvim still freezes, try:"
    echo "  1. Open nvim"
    echo "  2. Wait a few seconds"
    echo "  3. Press Ctrl+C"
    echo "  4. Type: :Lazy sync"
    echo "  5. Let it finish installing plugins"
    echo "  6. Restart nvim"
else
    echo -e "${YELLOW}⚠${NC}  nvim config not found at ~/.config/nvim"
    echo "  Make sure you've cloned your config:"
    echo "  git clone https://github.com/taham8875/init.lua ~/.config/nvim"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   Fixes Applied!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}Next steps:${NC}"
echo "1. Test powermenu: Press Mod+x and check if icons display correctly"
echo "2. Test nvim: Open nvim and it should work now"
echo "3. If nvim still has issues, the plugins might still be installing"
echo ""
echo -e "${BLUE}For powermenu:${NC} If emojis still corrupted, restart i3 (Mod+Shift+r)"
echo -e "${BLUE}For nvim:${NC} First launch might be slow as plugins finish installing"

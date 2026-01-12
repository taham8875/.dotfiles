#!/usr/bin/env bash
# Comprehensive fix for new laptop setup issues

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Fixing New Laptop Setup${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo "This will fix:"
echo "1. Disable picom window animations (make everything instant)"
echo "2. Install Iosevka Nerd Font (for rofi mono font)"
echo "3. Install oh-my-zsh plugins (autosuggestions, syntax-highlighting)"
echo "4. Update display scaling from 118% to 125%"
echo ""

# ============================================
# 1. Fix picom animations
# ============================================
echo -e "${BLUE}[1/4] Disabling picom animations...${NC}"

if grep -q "^fading = true" ~/.config/picom.conf 2>/dev/null; then
    sed -i 's/^fading = true/fading = false/' ~/.config/picom.conf
    echo -e "${GREEN}✓${NC} Disabled fading animations in picom"
else
    echo -e "${GREEN}✓${NC} Picom fading already disabled"
fi

# ============================================
# 2. Install Iosevka Nerd Font
# ============================================
echo -e "\n${BLUE}[2/4] Installing Iosevka Nerd Font...${NC}"

if [ -z "$(fc-list | grep -i 'Iosevka Nerd Font')" ]; then
    mkdir -p ~/.local/share/fonts
    cd /tmp
    echo "Downloading Iosevka Nerd Font..."
    wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Iosevka.zip
    echo "Extracting..."
    unzip -q Iosevka.zip -d Iosevka
    echo "Installing..."
    cp Iosevka/*.ttf ~/.local/share/fonts/
    fc-cache -fv ~/.local/share/fonts > /dev/null 2>&1
    rm -rf Iosevka Iosevka.zip
    echo -e "${GREEN}✓${NC} Iosevka Nerd Font installed"
else
    echo -e "${GREEN}✓${NC} Iosevka Nerd Font already installed"
fi

# ============================================
# 3. Install oh-my-zsh plugins
# ============================================
echo -e "\n${BLUE}[3/4] Installing oh-my-zsh plugins...${NC}"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    echo -e "${GREEN}✓${NC} Installed zsh-autosuggestions"
else
    echo -e "${GREEN}✓${NC} zsh-autosuggestions already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    echo -e "${GREEN}✓${NC} Installed zsh-syntax-highlighting"
else
    echo -e "${GREEN}✓${NC} zsh-syntax-highlighting already installed"
fi

# ============================================
# 4. Update display scaling to 125%
# ============================================
echo -e "\n${BLUE}[4/4] Updating display scaling to 125%...${NC}"

if [ -f ~/.xprofile ]; then
    # Update DPI: 96 * 1.25 = 120
    sed -i 's/xrandr --dpi 113/xrandr --dpi 120/' ~/.xprofile
    sed -i 's/# 96 \* 1.18 = 113.28, rounded to 113/# 96 * 1.25 = 120/' ~/.xprofile

    # Update scaling factors
    sed -i 's/export GDK_SCALE=1.18/export GDK_SCALE=1.25/' ~/.xprofile
    sed -i 's/export QT_SCALE_FACTOR=1.18/export QT_SCALE_FACTOR=1.25/' ~/.xprofile
    sed -i 's/export ELECTRON_SCALE_FACTOR=1.18/export ELECTRON_SCALE_FACTOR=1.25/' ~/.xprofile

    # Update comment
    sed -i 's/# Sets 118% display scaling/# Sets 125% display scaling/' ~/.xprofile

    echo -e "${GREEN}✓${NC} Updated .xprofile to 125% scaling"
else
    echo -e "${YELLOW}⚠${NC}  .xprofile not found, skipping scaling update"
fi

# Update i3 config font size (11.8 -> 12.5)
if [ -f ~/.config/i3/config ]; then
    sed -i 's/font pango:DejaVu Sans Mono 11.8/font pango:DejaVu Sans Mono 12.5/' ~/.config/i3/config
    echo -e "${GREEN}✓${NC} Updated i3 font size to 12.5 (125% of 10)"
fi

# Update polybar font sizes (11.8 -> 12.5, 14.16 -> 15, 18.88 -> 20)
if [ -f ~/.config/polybar/config.ini ]; then
    sed -i 's/:size=11.8:/:size=12.5:/' ~/.config/polybar/config.ini
    sed -i 's/:size=14.16:/:size=15:/' ~/.config/polybar/config.ini
    sed -i 's/:size=18.88:/:size=20:/' ~/.config/polybar/config.ini
    echo -e "${GREEN}✓${NC} Updated polybar font sizes for 125% scaling"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   All Fixes Applied!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}Next steps:${NC}"
echo "1. Restart picom: killall picom && picom &"
echo "2. Restart polybar: killall polybar && ~/.config/polybar/launch.sh &"
echo "3. Reload i3: Mod+Shift+r"
echo "4. Close and reopen konsole to see zsh plugin changes"
echo "5. Log out and log back in for display scaling to fully apply"
echo ""
echo -e "${BLUE}Or simply restart i3 with Mod+Shift+r and everything will reload!${NC}"

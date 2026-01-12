#!/usr/bin/env bash
# Complete system setup script for new Ubuntu installation
# Run this on a fresh Ubuntu install to replicate your environment

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Ubuntu Setup Script${NC}"
echo -e "${GREEN}========================================${NC}\n"

# Check if running on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release 2>/dev/null; then
    echo -e "${RED}Warning: This script is designed for Ubuntu${NC}"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${BLUE}This script will:${NC}"
echo "1. Update system packages"
echo "2. Install i3 window manager and desktop utilities"
echo "3. Install development tools (build-essential, git, etc.)"
echo "4. Install terminal tools (zsh, tmux, neovim, etc.)"
echo "5. Setup zsh as default shell"
echo "6. Clone and install your dotfiles"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Update system
echo -e "\n${GREEN}==> Updating system packages...${NC}"
sudo apt update
sudo apt upgrade -y

# Install i3 window manager and desktop environment
echo -e "\n${GREEN}==> Installing i3 window manager and desktop utilities...${NC}"
sudo apt install -y \
    i3 \
    polybar \
    rofi \
    dunst \
    picom \
    feh \
    xdotool \
    wmctrl \
    xclip \
    xsel \
    scrot \
    slop \
    ffmpeg \
    pavucontrol \
    brightnessctl \
    network-manager-gnome \
    blueman \
    zenity \
    notify-osd \
    libnotify-bin \
    imwheel \
    copyq \
    papirus-icon-theme \
    lxappearance \
    nitrogen \
    arandr

# Install fonts
echo -e "\n${GREEN}==> Installing fonts...${NC}"
sudo apt install -y \
    fonts-dejavu \
    fonts-dejavu-core \
    fonts-dejavu-extra \
    fonts-font-awesome \
    fonts-noto \
    fonts-noto-color-emoji \
    fonts-noto-mono \
    fonts-liberation \
    fonts-roboto

# Install JetBrainsMono Nerd Font (required for polybar icons/emojis)
echo -e "\n${GREEN}==> Installing JetBrainsMono Nerd Font...${NC}"
if [ ! -d "$HOME/.local/share/fonts" ] || [ -z "$(fc-list | grep -i 'JetBrainsMono')" ]; then
    mkdir -p ~/.local/share/fonts
    cd /tmp
    wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip -q JetBrainsMono.zip -d JetBrainsMono
    cp JetBrainsMono/*.ttf ~/.local/share/fonts/
    fc-cache -fv ~/.local/share/fonts > /dev/null 2>&1
    rm -rf JetBrainsMono JetBrainsMono.zip
    echo -e "${GREEN}✓${NC} JetBrainsMono Nerd Font installed"
else
    echo -e "${GREEN}✓${NC} JetBrainsMono Nerd Font already installed"
fi

# Install Iosevka Nerd Font (required for rofi mono font)
echo -e "\n${GREEN}==> Installing Iosevka Nerd Font...${NC}"
if [ ! -d "$HOME/.local/share/fonts" ] || [ -z "$(fc-list | grep -i 'Iosevka Nerd Font')" ]; then
    mkdir -p ~/.local/share/fonts
    cd /tmp
    wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Iosevka.zip
    unzip -q Iosevka.zip -d Iosevka
    cp Iosevka/*.ttf ~/.local/share/fonts/
    fc-cache -fv ~/.local/share/fonts > /dev/null 2>&1
    rm -rf Iosevka Iosevka.zip
    echo -e "${GREEN}✓${NC} Iosevka Nerd Font installed"
else
    echo -e "${GREEN}✓${NC} Iosevka Nerd Font already installed"
fi

# Install terminal emulators
echo -e "\n${GREEN}==> Installing terminal emulators...${NC}"
sudo apt install -y \
    alacritty \
    konsole

# Install shell and terminal tools
echo -e "\n${GREEN}==> Installing shell and terminal tools...${NC}"
sudo apt install -y \
    zsh \
    tmux \
    neovim \
    vim \
    curl \
    wget \
    git \
    htop \
    btop \
    neofetch \
    tree \
    ncdu \
    ranger \
    fzf \
    ripgrep \
    fd-find \
    bat \
    eza \
    tldr

# Install development tools
echo -e "\n${GREEN}==> Installing development tools...${NC}"
sudo apt install -y \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    gdb \
    python3 \
    python3-pip \
    python3-venv \
    python-is-python3 \
    nodejs \
    npm

# Install media tools
echo -e "\n${GREEN}==> Installing media tools...${NC}"
sudo apt install -y \
    mpv \
    vlc \
    gimp \
    obs-studio \
    screenkey \
    kdenlive

# Install file managers
echo -e "\n${GREEN}==> Installing file managers...${NC}"
sudo apt install -y \
    nemo \
    thunar

# Install archive tools
echo -e "\n${GREEN}==> Installing archive tools...${NC}"
sudo apt install -y \
    unzip \
    zip \
    tar \
    p7zip-full \
    rar \
    unrar

# Install system utilities
echo -e "\n${GREEN}==> Installing system utilities...${NC}"
sudo apt install -y \
    gnome-system-monitor \
    gnome-calculator \
    gnome-screenshot \
    gparted \
    timeshift \
    dconf-editor

# Setup zsh as default shell
echo -e "\n${GREEN}==> Setting up zsh as default shell...${NC}"
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo -e "${GREEN}✓${NC} Zsh set as default shell (will take effect after logout)"
else
    echo -e "${GREEN}✓${NC} Zsh is already the default shell"
fi

# Install oh-my-zsh (optional but recommended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "\n${GREEN}==> Installing oh-my-zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
else
    echo -e "${GREEN}✓${NC} oh-my-zsh already installed"
fi

# Install oh-my-zsh plugins
echo -e "\n${GREEN}==> Installing oh-my-zsh plugins...${NC}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    echo -e "${GREEN}✓${NC} Installed zsh-autosuggestions"
else
    echo -e "${GREEN}✓${NC} zsh-autosuggestions already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    echo -e "${GREEN}✓${NC} Installed zsh-syntax-highlighting"
else
    echo -e "${GREEN}✓${NC} zsh-syntax-highlighting already installed"
fi

# Install Rust (for cargo)
if ! command -v cargo &> /dev/null; then
    echo -e "\n${GREEN}==> Installing Rust...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo -e "${GREEN}✓${NC} Rust already installed"
fi

# Install starship prompt
if ! command -v starship &> /dev/null; then
    echo -e "\n${GREEN}==> Installing starship prompt...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo -e "${GREEN}✓${NC} Starship already installed"
fi

# Clone dotfiles if not already cloned
if [ ! -d "$HOME/.dotfiles" ]; then
    echo -e "\n${GREEN}==> Cloning dotfiles repository...${NC}"
    git clone https://github.com/taham8875/.dotfiles.git "$HOME/.dotfiles"
else
    echo -e "${GREEN}✓${NC} Dotfiles already cloned"
    cd "$HOME/.dotfiles"
    git pull
fi

# Run dotfiles installer
echo -e "\n${GREEN}==> Installing dotfiles (creating symlinks)...${NC}"
cd "$HOME/.dotfiles"
chmod +x install.sh
./install.sh

# Setup imwheel for mouse scroll speed
echo -e "\n${GREEN}==> Setting up imwheel...${NC}"
if ! pgrep -x "imwheel" > /dev/null; then
    imwheel -b "4 5" &
    echo -e "${GREEN}✓${NC} imwheel started"
fi

# Add imwheel to autostart if not already there
if [ ! -f "$HOME/.config/autostart/imwheel.desktop" ]; then
    mkdir -p "$HOME/.config/autostart"
    cat > "$HOME/.config/autostart/imwheel.desktop" << 'EOL'
[Desktop Entry]
Type=Application
Name=IMWheel
Exec=imwheel -b "4 5"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOL
    echo -e "${GREEN}✓${NC} Added imwheel to autostart"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}Manual steps remaining:${NC}\n"

echo -e "${BLUE}1. Git Configuration:${NC}"
echo "   Update your git credentials in ~/.gitconfig:"
echo "   git config --global user.email \"your.email@example.com\""
echo "   git config --global user.name \"Your Name\""
echo ""

echo -e "${BLUE}2. Download Wallpaper:${NC}"
echo "   Download your wallpaper to: ~/Downloads/wallhaven-5g22q5.png"
echo "   Or update the path in: ~/.config/i3/config"
echo ""

echo -e "${BLUE}3. Install Additional Software (if needed):${NC}"
echo "   - VS Code / Cursor: Download from official sites"
echo "   - Google Chrome / Microsoft Edge: Download from official sites"
echo "   - Docker: curl -fsSL https://get.docker.com | sh"
echo "   - Flutter: Download from https://flutter.dev/docs/get-started/install"
echo "   - Node.js LTS: Consider installing via nvm"
echo "   - Nvim config: Clone your neovim configuration repository"
echo ""

echo -e "${BLUE}4. Setup SSH Keys:${NC}"
echo "   ssh-keygen -t ed25519 -C \"your.email@example.com\""
echo "   ssh-add ~/.ssh/id_ed25519"
echo "   Add public key to GitHub: https://github.com/settings/keys"
echo ""

echo -e "${BLUE}5. Login Manager:${NC}"
echo "   Log out and select 'i3' as your session at the login screen"
echo ""

echo -e "${BLUE}6. Setup Brightness Control (if needed):${NC}"
echo "   Run: sudo ~/.config/i3/scripts/setup-brightness-permissions.sh"
echo ""

echo -e "${BLUE}7. Arabic Keyboard (if needed):${NC}"
echo "   The setup script in i3 config should handle this automatically"
echo "   Test with: Alt+Shift to switch layouts"
echo ""

echo -e "${GREEN}Tip:${NC} You may want to reboot now to ensure all changes take effect."
echo ""
echo -e "${YELLOW}Reboot now? (y/N)${NC} "
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Rebooting...${NC}"
    sudo reboot
else
    echo -e "${GREEN}Remember to log out and select i3 at the login screen!${NC}"
fi

#!/usr/bin/env bash
# Install all packages on new system from exported lists

set -e

PACKAGE_DIR="$HOME/.dotfiles/package-lists"

if [ ! -d "$PACKAGE_DIR" ]; then
    echo "Error: Package lists not found at $PACKAGE_DIR"
    echo "Run export-packages.sh on your old machine first!"
    exit 1
fi

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Installing Packages${NC}"
echo -e "${GREEN}========================================${NC}\n"

# ============================================
# APT Packages
# ============================================
echo -e "${BLUE}[1/7] Installing APT packages...${NC}"
if [ -f "$PACKAGE_DIR/apt-manual.txt" ] && [ "$(cat "$PACKAGE_DIR/apt-manual.txt")" != "apt not installed" ]; then
    echo "This will install $(wc -l < "$PACKAGE_DIR/apt-manual.txt") APT packages"
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt update
        cat "$PACKAGE_DIR/apt-manual.txt" | xargs sudo apt install -y
        echo -e "${GREEN}✓${NC} APT packages installed"
    else
        echo -e "${YELLOW}⊘${NC} Skipped APT packages"
    fi
else
    echo -e "${YELLOW}⊘${NC} No APT packages to install"
fi

# ============================================
# Snap Packages
# ============================================
echo -e "\n${BLUE}[2/7] Installing Snap packages...${NC}"
if [ -f "$PACKAGE_DIR/snap.txt" ] && [ "$(cat "$PACKAGE_DIR/snap.txt")" != "snap not installed" ]; then
    echo "Found $(wc -l < "$PACKAGE_DIR/snap.txt") Snap packages"
    read -p "Install Snap packages? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while IFS= read -r package; do
            echo "Installing $package..."
            sudo snap install "$package" || echo "Failed to install $package"
        done < "$PACKAGE_DIR/snap.txt"
        echo -e "${GREEN}✓${NC} Snap packages installed"
    else
        echo -e "${YELLOW}⊘${NC} Skipped Snap packages"
    fi
else
    echo -e "${YELLOW}⊘${NC} No Snap packages to install"
fi

# ============================================
# Flatpak Packages
# ============================================
echo -e "\n${BLUE}[3/7] Installing Flatpak packages...${NC}"
if [ -f "$PACKAGE_DIR/flatpak.txt" ] && [ "$(cat "$PACKAGE_DIR/flatpak.txt")" != "flatpak not installed" ]; then
    echo "Found $(wc -l < "$PACKAGE_DIR/flatpak.txt") Flatpak packages"
    read -p "Install Flatpak packages? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while IFS= read -r package; do
            echo "Installing $package..."
            flatpak install -y "$package" || echo "Failed to install $package"
        done < "$PACKAGE_DIR/flatpak.txt"
        echo -e "${GREEN}✓${NC} Flatpak packages installed"
    else
        echo -e "${YELLOW}⊘${NC} Skipped Flatpak packages"
    fi
else
    echo -e "${YELLOW}⊘${NC} No Flatpak packages to install"
fi

# ============================================
# NPM Global Packages
# ============================================
echo -e "\n${BLUE}[4/7] Installing NPM global packages...${NC}"
if [ -f "$PACKAGE_DIR/npm-global.txt" ] && [ "$(cat "$PACKAGE_DIR/npm-global.txt")" != "npm not installed" ]; then
    if command -v npm &> /dev/null; then
        echo "Found $(wc -l < "$PACKAGE_DIR/npm-global.txt") NPM packages"
        read -p "Install NPM global packages? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            while IFS= read -r package; do
                echo "Installing $package..."
                npm install -g "$package" || echo "Failed to install $package"
            done < "$PACKAGE_DIR/npm-global.txt"
            echo -e "${GREEN}✓${NC} NPM packages installed"
        else
            echo -e "${YELLOW}⊘${NC} Skipped NPM packages"
        fi
    else
        echo -e "${RED}✗${NC} NPM not installed. Install Node.js first."
    fi
else
    echo -e "${YELLOW}⊘${NC} No NPM packages to install"
fi

# ============================================
# Python Pip Packages
# ============================================
echo -e "\n${BLUE}[5/7] Installing Python pip packages...${NC}"
if [ -f "$PACKAGE_DIR/pip3.txt" ] && [ "$(cat "$PACKAGE_DIR/pip3.txt")" != "pip3 not installed" ]; then
    if command -v pip3 &> /dev/null; then
        echo "Found $(wc -l < "$PACKAGE_DIR/pip3.txt") pip packages"
        read -p "Install pip packages? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pip3 install -r "$PACKAGE_DIR/pip3.txt"
            echo -e "${GREEN}✓${NC} pip packages installed"
        else
            echo -e "${YELLOW}⊘${NC} Skipped pip packages"
        fi
    else
        echo -e "${RED}✗${NC} pip3 not installed. Install Python3 first."
    fi
else
    echo -e "${YELLOW}⊘${NC} No pip packages to install"
fi

# ============================================
# Cargo Packages
# ============================================
echo -e "\n${BLUE}[6/7] Installing Cargo packages...${NC}"
if [ -f "$PACKAGE_DIR/cargo.txt" ] && [ "$(cat "$PACKAGE_DIR/cargo.txt")" != "cargo not installed" ]; then
    if command -v cargo &> /dev/null; then
        echo "Found $(wc -l < "$PACKAGE_DIR/cargo.txt") Cargo packages"
        read -p "Install Cargo packages? (This may take a while) (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            while IFS= read -r package; do
                echo "Installing $package..."
                cargo install "$package" || echo "Failed to install $package"
            done < "$PACKAGE_DIR/cargo.txt"
            echo -e "${GREEN}✓${NC} Cargo packages installed"
        else
            echo -e "${YELLOW}⊘${NC} Skipped Cargo packages"
        fi
    else
        echo -e "${RED}✗${NC} Cargo not installed. Install Rust first."
    fi
else
    echo -e "${YELLOW}⊘${NC} No Cargo packages to install"
fi

# ============================================
# Special Installs (Manual)
# ============================================
echo -e "\n${BLUE}[7/7] Special installations...${NC}"
if [ -f "$PACKAGE_DIR/special-installs.txt" ]; then
    echo -e "${YELLOW}The following were detected on your old system:${NC}"
    cat "$PACKAGE_DIR/special-installs.txt"
    echo ""
    echo -e "${YELLOW}These need to be installed manually:${NC}"
    echo ""

    # Claude Code
    if grep -q "claude-code" "$PACKAGE_DIR/special-installs.txt"; then
        echo -e "${BLUE}Claude Code:${NC}"
        echo "  npm install -g @anthropic-ai/claude-code"
    fi

    # Docker
    if grep -q "docker" "$PACKAGE_DIR/special-installs.txt"; then
        echo -e "${BLUE}Docker:${NC}"
        echo "  curl -fsSL https://get.docker.com | sh"
        echo "  sudo usermod -aG docker \$USER"
    fi

    # Flutter
    if grep -q "flutter" "$PACKAGE_DIR/special-installs.txt"; then
        echo -e "${BLUE}Flutter:${NC}"
        echo "  Download from: https://flutter.dev/docs/get-started/install"
    fi

    # GitHub CLI
    if grep -q "gh" "$PACKAGE_DIR/special-installs.txt"; then
        echo -e "${BLUE}GitHub CLI (gh):${NC}"
        echo "  sudo apt install gh"
    fi

    # VS Code
    if grep -q "vscode" "$PACKAGE_DIR/special-installs.txt"; then
        echo -e "${BLUE}VS Code:${NC}"
        echo "  sudo snap install code --classic"
    fi
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}Note:${NC} Some packages may have failed to install due to:"
echo "  - Package name changes"
echo "  - Dependencies not met"
echo "  - Different Ubuntu version"
echo ""
echo "Review the output above and manually install any failed packages."

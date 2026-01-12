#!/usr/bin/env bash
# Export all installed packages from current system

set -e

OUTPUT_DIR="$HOME/.dotfiles/package-lists"
mkdir -p "$OUTPUT_DIR"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}Exporting installed packages...${NC}\n"

# ============================================
# APT Packages (manually installed)
# ============================================
echo -e "${BLUE}[1/8] Exporting APT packages...${NC}"
apt-mark showmanual > "$OUTPUT_DIR/apt-manual.txt"
echo -e "${GREEN}✓${NC} Saved $(wc -l < "$OUTPUT_DIR/apt-manual.txt") manually installed APT packages"

# ============================================
# Snap Packages
# ============================================
echo -e "\n${BLUE}[2/8] Exporting Snap packages...${NC}"
if command -v snap &> /dev/null; then
    snap list | tail -n +2 | awk '{print $1}' > "$OUTPUT_DIR/snap.txt"
    echo -e "${GREEN}✓${NC} Saved $(wc -l < "$OUTPUT_DIR/snap.txt") Snap packages"
else
    echo "snap not installed" > "$OUTPUT_DIR/snap.txt"
    echo -e "${GREEN}✓${NC} Snap not installed"
fi

# ============================================
# Flatpak Packages
# ============================================
echo -e "\n${BLUE}[3/8] Exporting Flatpak packages...${NC}"
if command -v flatpak &> /dev/null; then
    flatpak list --app --columns=application > "$OUTPUT_DIR/flatpak.txt"
    echo -e "${GREEN}✓${NC} Saved $(wc -l < "$OUTPUT_DIR/flatpak.txt") Flatpak packages"
else
    echo "flatpak not installed" > "$OUTPUT_DIR/flatpak.txt"
    echo -e "${GREEN}✓${NC} Flatpak not installed"
fi

# ============================================
# NPM Global Packages
# ============================================
echo -e "\n${BLUE}[4/8] Exporting NPM global packages...${NC}"
if command -v npm &> /dev/null; then
    npm list -g --depth=0 --json 2>/dev/null | jq -r '.dependencies | keys[]' 2>/dev/null > "$OUTPUT_DIR/npm-global.txt" || echo "npm" > "$OUTPUT_DIR/npm-global.txt"
    echo -e "${GREEN}✓${NC} Saved $(wc -l < "$OUTPUT_DIR/npm-global.txt") NPM global packages"
else
    echo "npm not installed" > "$OUTPUT_DIR/npm-global.txt"
    echo -e "${GREEN}✓${NC} NPM not installed"
fi

# ============================================
# Python Pip Packages
# ============================================
echo -e "\n${BLUE}[5/8] Exporting Python pip packages...${NC}"
if command -v pip3 &> /dev/null; then
    pip3 list --format=freeze > "$OUTPUT_DIR/pip3.txt"
    echo -e "${GREEN}✓${NC} Saved $(wc -l < "$OUTPUT_DIR/pip3.txt") pip packages"
else
    echo "pip3 not installed" > "$OUTPUT_DIR/pip3.txt"
    echo -e "${GREEN}✓${NC} pip3 not installed"
fi

# ============================================
# Cargo Packages (Rust)
# ============================================
echo -e "\n${BLUE}[6/8] Exporting Cargo packages...${NC}"
if command -v cargo &> /dev/null; then
    cargo install --list | grep -E "^[a-z]" | awk '{print $1}' > "$OUTPUT_DIR/cargo.txt"
    echo -e "${GREEN}✓${NC} Saved $(wc -l < "$OUTPUT_DIR/cargo.txt") Cargo packages"
else
    echo "cargo not installed" > "$OUTPUT_DIR/cargo.txt"
    echo -e "${GREEN}✓${NC} Cargo not installed"
fi

# ============================================
# Go Packages
# ============================================
echo -e "\n${BLUE}[7/8] Exporting Go packages...${NC}"
if command -v go &> /dev/null && [ -d "$HOME/go/bin" ]; then
    ls -1 "$HOME/go/bin" > "$OUTPUT_DIR/go-binaries.txt"
    echo -e "${GREEN}✓${NC} Saved $(wc -l < "$OUTPUT_DIR/go-binaries.txt") Go binaries"
else
    echo "go not installed or no binaries" > "$OUTPUT_DIR/go-binaries.txt"
    echo -e "${GREEN}✓${NC} Go not installed or no binaries"
fi

# ============================================
# Special Manual Installs
# ============================================
echo -e "\n${BLUE}[8/8] Detecting special installs...${NC}"
{
    echo "# Special installations detected on this system"
    echo "# Install these manually on new system"
    echo ""

    command -v claude &> /dev/null && echo "claude-code: $(which claude)"
    command -v docker &> /dev/null && echo "docker: $(which docker)"
    command -v kubectl &> /dev/null && echo "kubectl: $(which kubectl)"
    command -v flutter &> /dev/null && echo "flutter: $(which flutter)"
    command -v aws &> /dev/null && echo "aws-cli: $(which aws)"
    command -v gh &> /dev/null && echo "gh (GitHub CLI): $(which gh)"
    command -v code &> /dev/null && echo "vscode: $(which code)"
    command -v cursor &> /dev/null && echo "cursor: $(which cursor)"

} > "$OUTPUT_DIR/special-installs.txt"
echo -e "${GREEN}✓${NC} Detected special installations"

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   Package Export Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo "Exported package lists saved to:"
echo "  $OUTPUT_DIR/"
echo ""
echo "Files created:"
ls -lh "$OUTPUT_DIR"
echo ""
echo "To install on new machine:"
echo "  1. Copy ~/.dotfiles to new machine"
echo "  2. Run: ~/.dotfiles/install-packages.sh"

#!/usr/bin/env bash
# Fix tmux configuration not loading

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Fixing Tmux Configuration${NC}"
echo -e "${GREEN}========================================${NC}\n"

# ============================================
# Install TPM (Tmux Plugin Manager)
# ============================================
echo -e "${BLUE}[1/3] Installing TPM (Tmux Plugin Manager)...${NC}"

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    echo "Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo -e "${GREEN}✓${NC} TPM installed to ~/.config/tmux/plugins/tpm"
else
    echo -e "${GREEN}✓${NC} TPM already installed"
fi

# ============================================
# Fix tmux.conf to point to correct TPM path
# ============================================
echo -e "\n${BLUE}[2/3] Updating tmux.conf TPM path...${NC}"

TMUX_CONF="$HOME/.config/tmux/tmux.conf"

if [ -f "$TMUX_CONF" ]; then
    # Check if it uses old path
    if grep -q "~/.tmux/plugins/tpm/tpm" "$TMUX_CONF"; then
        sed -i "s|~/.tmux/plugins/tpm/tpm|~/.config/tmux/plugins/tpm/tpm|g" "$TMUX_CONF"
        echo -e "${GREEN}✓${NC} Updated TPM path in tmux.conf"
    else
        echo -e "${GREEN}✓${NC} TPM path already correct"
    fi
else
    echo -e "${GREEN}✓${NC} tmux.conf not found (will be created by dotfiles symlink)"
fi

# ============================================
# Install tmux plugins
# ============================================
echo -e "\n${BLUE}[3/3] Installing tmux plugins...${NC}"

# Kill any existing tmux sessions to ensure clean install
tmux kill-server 2>/dev/null || true

# Start a detached tmux session and install plugins
tmux new-session -d -s temp-install
tmux send-keys -t temp-install "$TPM_DIR/bin/install_plugins" Enter
sleep 3
tmux kill-session -t temp-install 2>/dev/null || true

echo -e "${GREEN}✓${NC} Tmux plugins installed"

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   Tmux Fix Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${BLUE}Next steps:${NC}"
echo "1. Start a new tmux session: tmux"
echo "2. Your config should be loaded with all plugins"
echo "3. Prefix is Ctrl+Space (not Ctrl+b)"
echo ""
echo -e "${BLUE}Installed plugins:${NC}"
echo "  - tmux-sensible (better defaults)"
echo "  - vim-tmux-navigator (seamless vim/tmux navigation)"
echo "  - tmux-yank (better copy/paste)"
echo "  - rose-pine theme"
echo ""
echo -e "${BLUE}Useful commands:${NC}"
echo "  - Prefix + r: Reload config"
echo "  - Prefix + I: Install/update plugins"
echo "  - Alt+h/j/k/l: Navigate panes without prefix"

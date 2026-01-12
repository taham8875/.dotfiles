# ============================================
# Zsh Configuration - Oh My Zsh Minimal Setup
# ============================================

# Keep your existing PATH and tools
PATH="$PATH:$HOME/.rvm/bin"
PATH="~/development/flutter/bin:$PATH"
# Go paths (was in bash config, needed for zsh)
PATH="$PATH:/usr/local/go/bin"
PATH="$PATH:$HOME/go/bin"
export PATH

# RVM (Ruby Version Manager)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
rvm use default &> /dev/null

# Envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# NVM (Node Version Manager)
export NVM_DIR="/home/taha/.nvm"
[ -s "/home/taha/.nvm/nvm.sh" ] && . "/home/taha/.nvm/nvm.sh"
[ -s "/home/taha/.nvm/bash_completion" ] && . "/home/taha/.nvm/bash_completion"
nvm use default >/dev/null 2>&1

# ============================================
# Oh My Zsh
# ============================================

export ZSH="$HOME/.oh-my-zsh"

# Theme - Simple and clean (robbyrussell is the default)
ZSH_THEME="robbyrussell"

# Plugins - Git + Autocomplete features
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================
# Autosuggestions Configuration
# ============================================

# Autosuggestions color (dimmed gray to match your theme)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086,bold"

# Accept suggestion with right arrow key
bindkey '^[[C' forward-char
bindkey '^[[1;5C' forward-word

# ============================================
# Zsh Options
# ============================================

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CORRECT
setopt CORRECT_ALL

# Completion
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt LIST_PACKED
setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

# Other
setopt EXTENDED_GLOB
setopt NO_BEEP
setopt NO_NOMATCH
setopt MULTIOS
setopt INTERACTIVE_COMMENTS

# ============================================
# Key Bindings
# ============================================

# Better history search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# Better word navigation
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[^?' backward-kill-word

# ============================================
# Completion System
# ============================================

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# ============================================
# Environment Variables
# ============================================

export EDITOR='vim'
export VISUAL='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS='-RFX'

# =============================================
# Custom Aliases
# ===========================================
alias gdsx='git diff --staged | xclip -selection clipboard'

# =============================================
# Custom Functions
# ===========================================
# Quick markdown viewer - converts md to PDF, opens in Edge, then deletes PDF
mdview() {
    if [ $# -eq 0 ]; then
        echo "Usage: mdview <markdown-file>"
        return 1
    fi

    local md_file="$1"
    
    if [ ! -f "$md_file" ]; then
        echo "Error: File '$md_file' not found"
        return 1
    fi

    if ! command -v mdpdf &> /dev/null; then
        echo "Error: mdpdf is not installed. Install it with: npm install -g mdpdf"
        return 1
    fi

    local pdf_file="${md_file%.md}.pdf"
    
    echo "Converting $md_file to PDF..."
    if ! mdpdf "$md_file"; then
        echo "Error: Failed to convert markdown to PDF"
        return 1
    fi

    if [ ! -f "$pdf_file" ]; then
        echo "Error: PDF file was not created"
        return 1
    fi

    echo "Opening PDF in Microsoft Edge..."
    microsoft-edge "$pdf_file" &> /dev/null &

    (
        sleep 3
        if [ -f "$pdf_file" ]; then
            rm -f "$pdf_file"
            echo "Cleaned up temporary PDF file"
        fi
    ) &

    echo "PDF opened. It will be automatically deleted in a few seconds."
}


# ============================================
# End of Configuration
# ============================================

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/taha/.dart-cli-completion/zsh-config.zsh ]] && . /home/taha/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

alias screenkey='screenkey --timeout 0.7'

# opencode
export PATH=/home/taha/.opencode/bin:$PATH

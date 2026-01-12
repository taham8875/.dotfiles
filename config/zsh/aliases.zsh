# ============================================
# Useful Aliases for Development
# ============================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Listings
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias l='ls -lh'
alias lt='ls -lhrt'  # Sort by time
alias lS='ls -lhS'   # Sort by size

# Modern alternatives (if installed)
if command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -lh'
    alias la='exa -lah'
    alias tree='exa --tree'
fi

if command -v bat &> /dev/null; then
    alias cat='bat'
fi

# Git shortcuts
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias glog='git log --oneline --graph --decorate'
alias gst='git stash'
alias gsp='git stash pop'

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias top='htop'  # If htop is installed

# Quick edits
alias zshrc='$EDITOR ~/.zshrc'
alias vimrc='$EDITOR ~/.vimrc'
alias i3config='$EDITOR ~/.config/i3/config'
alias polybarconfig='$EDITOR ~/.config/polybar/config.ini'

# Network
alias ping='ping -c 5'
alias ports='netstat -tulanp'

# Search
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Development
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Flutter
alias f='flutter'
alias fd='flutter doctor'
alias fr='flutter run'
alias fb='flutter build'

# Node
alias ni='npm install'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'

# Misc
alias c='clear'
alias h='history'
alias path='echo $PATH | tr ":" "\n"'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Arabic-friendly
alias ar='setxkbmap -layout us,ara -option grp:alt_shift_toggle'
alias en='setxkbmap -layout us'














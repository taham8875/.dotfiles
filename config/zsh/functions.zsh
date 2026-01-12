# ============================================
# Useful Zsh Functions
# ============================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"       ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find files
ff() {
    find . -type f -iname "*$1*"
}

# Find directories (renamed to avoid conflict with flutter doctor alias)
fdir() {
    find . -type d -iname "*$1*"
}

# Git commit with message
gcm() {
    git commit -m "$1"
}

# Quick git push
gpush() {
    git push origin $(git branch --show-current)
}

# Create a new directory and enter it
take() {
    mkdir -p "$1" && cd "$1"
}

# Show disk usage of current directory
dus() {
    du -sh * | sort -h
}

# Kill process by name
killp() {
    pkill -f "$1"
}

# Weather (if wttr.in is available)
weather() {
    curl -s "wttr.in/$1?format=3"
}

# Create a Python virtual environment
mkvenv() {
    python3 -m venv "$1" && source "$1/bin/activate"
}

# Quick server (Python)
serve() {
    local port=${1:-8000}
    python3 -m http.server "$port"
}

# Git log with graph
glg() {
    git log --oneline --graph --decorate --all -20
}

# Copy file with progress
cpp() {
    rsync -avh --progress "$1" "$2"
}

# Show top 10 commands from history
top10() {
    history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
}

# Quick backup
backup() {
    cp -r "$1" "$1.backup"
    echo "Backup created: $1.backup"
}

# Show public IP
myip() {
    curl -s ifconfig.me
    echo
}

# Show local IP
localip() {
    hostname -I | awk '{print $1}'
}

# Count files in directory
count() {
    find . -type f | wc -l
}

# Show directory tree
tree() {
    if command -v tree &> /dev/null; then
        command tree "$@"
    else
        find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
    fi
}


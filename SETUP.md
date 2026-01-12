# New Machine Setup Guide

Complete guide to set up a fresh Ubuntu installation with your dotfiles.

## Quick Start (One Command)

On your new Ubuntu machine, open a terminal and run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/taham8875/.dotfiles/main/setup-new-machine.sh)
```

**OR** manually:

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/taham8875/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x setup-new-machine.sh
./setup-new-machine.sh
```

This will automatically:
- Install all required packages
- Install i3 window manager and utilities
- Install development tools
- Setup zsh as default shell
- Install your dotfiles
- Configure everything

## What Gets Installed

### Window Manager & Desktop
- i3, polybar, rofi, dunst, picom
- Wallpaper setter (feh), screenshot tools (scrot, slop)
- System tray apps (nm-applet, blueman)

### Terminal & Shell
- alacritty, konsole
- zsh + oh-my-zsh
- tmux, neovim
- starship prompt

### System Monitoring
- htop, btop, neofetch

### Development Tools
- build-essential (gcc, g++, make)
- git, curl, wget
- Python 3, Node.js, npm
- Rust (cargo)

### Media & Utilities
- mpv, vlc, obs-studio
- gimp, kdenlive
- File managers (nemo, thunar)

## After Installation

### 1. Reboot and Select i3
Log out and select **i3** as your window manager at the login screen.

### 2. Update Git Config
```bash
git config --global user.email "taha.m8875@gmail.com"
git config --global user.name "taham8875"
```

### 3. Download Wallpaper
Download your wallpaper to `~/Downloads/wallhaven-5g22q5.png` or update the path in `~/.config/i3/config`.

### 4. Setup SSH Keys
```bash
ssh-keygen -t ed25519 -C "taha.m8875@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub  # Add this to GitHub
```

### 5. Install Additional Software

**Browsers:**
```bash
# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Microsoft Edge
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
sudo apt update
sudo apt install -y microsoft-edge-stable
```

**Code Editors:**
```bash
# VS Code
sudo snap install code --classic

# Cursor (download from cursor.sh)
```

**Docker:**
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

**Flutter:**
```bash
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz
tar xf flutter_linux_3.x.x-stable.tar.xz
# PATH already configured in .zshenv
```

**Node.js (via nvm):**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts
nvm use --lts
```

**Neovim Config:**
```bash
git clone <your-nvim-config-repo> ~/.config/nvim
```

### 6. Brightness Control Permissions
If brightness keys don't work:
```bash
sudo ~/.config/i3/scripts/setup-brightness-permissions.sh
```

### 7. Arabic Keyboard
Should work automatically. Test with **Alt+Shift** to switch layouts.

If not working:
```bash
~/.config/i3/scripts/setup-arabic-keyboard.sh
```

## i3 Key Bindings Cheatsheet

| Key | Action |
|-----|--------|
| `Mod+Enter` | Open terminal (alacritty) |
| `Mod+d` | Application launcher (rofi) |
| `Mod+Shift+q` | Close window |
| `Mod+Shift+e` | Exit i3 |
| `Mod+Shift+r` | Restart i3 |
| `Mod+Shift+c` | Reload i3 config |
| `Mod+1-9` | Switch to workspace 1-9 |
| `Mod+Shift+1-9` | Move window to workspace 1-9 |
| `Mod+h/j/k/l` | Focus window (vim keys) |
| `Mod+Shift+h/j/k/l` | Move window (vim keys) |
| `Mod+f` | Fullscreen toggle |
| `Mod+Shift+space` | Float/tile toggle |
| `Mod+Shift+s` | Screenshot |
| `Mod+Shift+r` | Screen recording (area select) |
| `Mod+Shift+b` | Re-apply Arabic keyboard |

## Troubleshooting

### Display Scaling Not Working
The `.xprofile` should handle this automatically. If not, check:
```bash
cat ~/.xprofile
xrdb -query | grep dpi
```

### Mouse Scroll Too Fast/Slow
Edit `~/.imwheelrc` and adjust the multiplier (currently 2).

### Fonts Look Wrong
```bash
fc-cache -fv
```

### Sound Not Working
```bash
sudo apt install pavucontrol
pavucontrol  # Check output device
```

### Network Manager Not Showing
```bash
nm-applet &
```

## Backup Strategy

Your dotfiles are automatically backed up to GitHub. To sync changes:

```bash
cd ~/.dotfiles
git add .
git commit -m "update configs"
git push
```

## Support

- Dotfiles: https://github.com/taham8875/.dotfiles
- i3 docs: https://i3wm.org/docs/
- Arch Wiki: https://wiki.archlinux.org/ (excellent Linux resource)

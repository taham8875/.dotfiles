# .dotfiles

Personal Linux configuration files for i3 + X11 environment

## What's Included

### Window Manager & Desktop
- **i3** - Tiling window manager with custom keybindings
- **polybar** - Status bar with system info, screencast indicator
- **rofi** - Application launcher and dmenu replacement
- **picom** - Compositor (shadows, fading, transparency)
- **dunst** - Notification daemon

### Terminal & Shell
- **alacritty** - GPU-accelerated terminal with rosepine theme
- **konsole** - KDE terminal with rosepine colorscheme
- **zsh** (zshrc, zshenv) - Shell config with aliases, functions, and PATH setup
- **tmux** - Terminal multiplexer with custom config
- **starship** - Minimal shell prompt (git branch only)

### System Monitoring
- **btop** - Modern system monitor
- **htop** - Traditional system monitor
- **neofetch** - System info display

### Development
- **gitconfig** - Git config (nvim editor, main branch default)

### Display & Input
- **xprofile** - 118% display scaling for all apps (X11, GTK, Qt, Electron)
- **imwheelrc** - Mouse wheel scroll speed (2x multiplier, preserves Ctrl+scroll zoom)
- **gtk-3.0/4.0** - GTK theme settings
- **autostart** - Auto-start applications

### Utilities
- **mpv** - Media player config
- **screenkey** - On-screen key display for recordings
- **copyq** - Clipboard manager config

### i3 Scripts
Located in `i3/scripts/`:
- Screen recording with area selection (slop)
- WiFi/Bluetooth management (GUI & terminal)
- Brightness control
- Mouse scroll speed adjustment
- Workspace booster
- Arabic keyboard support
- CopyQ integration
- Display scaling setup

## Installation

### Quick Setup (New System)

```bash
cd ~
git clone https://github.com/taham8875/.dotfiles.git
cd .dotfiles
chmod +x install.sh
./install.sh
```

### Manual Setup

```bash
cd ~/.dotfiles

# Create symlinks
ln -sf ~/.dotfiles/i3 ~/.config/i3
ln -sf ~/.dotfiles/polybar ~/.config/polybar
ln -sf ~/.dotfiles/rofi ~/.config/rofi
ln -sf ~/.dotfiles/config/alacritty ~/.config/alacritty
ln -sf ~/.dotfiles/config/zsh ~/.config/zsh
ln -sf ~/.dotfiles/dunst ~/.config/dunst
ln -sf ~/.dotfiles/tmux ~/.config/tmux
ln -sf ~/.dotfiles/gtk-3.0 ~/.config/gtk-3.0
ln -sf ~/.dotfiles/gtk-4.0 ~/.config/gtk-4.0
ln -sf ~/.dotfiles/autostart ~/.config/autostart
ln -sf ~/.dotfiles/ghostty ~/.config/ghostty
ln -sf ~/.dotfiles/neofetch ~/.config/neofetch
ln -sf ~/.dotfiles/btop ~/.config/btop
ln -sf ~/.dotfiles/htop ~/.config/htop
ln -sf ~/.dotfiles/mpv ~/.config/mpv
ln -sf ~/.dotfiles/konsole ~/.config/konsole
ln -sf ~/.dotfiles/picom.conf ~/.config/picom.conf
ln -sf ~/.dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/.dotfiles/screenkey.json ~/.config/screenkey.json

# Home directory files
ln -sf ~/.dotfiles/.xprofile ~/.xprofile
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/zshrc ~/.zshrc
ln -sf ~/.dotfiles/.zshenv ~/.zshenv
ln -sf ~/.dotfiles/.imwheelrc ~/.imwheelrc
```

## Dependencies

Required packages (Ubuntu/Debian):

```bash
sudo apt install -y \
    i3 polybar rofi dunst picom \
    alacritty konsole zsh tmux \
    neofetch btop htop \
    feh slop ffmpeg \
    xdotool wmctrl \
    zenity notify-send \
    papirus-icon-theme \
    fonts-dejavu fonts-noto-color-emoji \
    brightnessctl pactl \
    imwheel
```

Optional:
- `starship` - Shell prompt (install from https://starship.rs)
- `copyq` - Clipboard manager
- `mpv` - Media player

## Key Features

### Display Scaling
118% scaling configured in `.xprofile` for:
- X11 (DPI 113)
- GTK apps (GDK_SCALE)
- Qt apps (QT_SCALE_FACTOR)
- Electron apps (VS Code, Discord, etc.)

### i3 Keybindings Highlights
- `Mod+Enter` - Terminal (alacritty)
- `Mod+d` - App launcher (rofi)
- `Mod+Shift+s` - Screenshot
- `Mod+Shift+r` - Screen recording (with area selection)
- `Mod+Shift+b` - Re-apply Arabic keyboard layout
- See `i3/config` for full list

### Theme
- **Rosepine Dark** - Consistent purple/magenta theme across all apps

## Notes

- Git credentials are NOT stored in this repo (see `.gitignore`)
- Nvim config has its own separate repo
- Some scripts require `sudo` permissions (brightness control)
- Wallpaper path in i3 config: `~/Downloads/wallhaven-5g22q5.png`

## Security

This is a public repository. The following are ignored:
- `.git-credentials` (passwords)
- `.ssh/` keys
- `.env` files
- History files
- Private keys/certificates

## Contributing

These are personal configs, but feel free to fork and adapt for your own use!

## License

MIT - Use freely!

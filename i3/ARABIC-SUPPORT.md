# Arabic Support Setup Guide

## What's Been Configured

1. **Keyboard Layouts**: English (US) + Arabic
2. **Input Method**: IBus or fcitx5 (if installed)
3. **Font**: Changed to DejaVu Sans Mono (supports Arabic/RTL)
4. **Keybindings**: Added layout switching

## Installation

### 1. Install Arabic Keyboard Layouts
```bash
sudo apt install keyboard-configuration
```

### 2. Install Arabic Fonts (Recommended)
```bash
# Install Noto Arabic fonts (best for Arabic text)
sudo apt install fonts-noto-arabic fonts-arabeyes

# Or DejaVu (already installed)
sudo apt install fonts-dejavu
```

### 3. Install Input Method (Choose one)

**Option A: IBus (Recommended)**
```bash
sudo apt install ibus ibus-arabic
# Then configure: ibus-setup
```

**Option B: fcitx5 (Alternative)**
```bash
sudo apt install fcitx5 fcitx5-arabic
```

## Keyboard Layout Switching

### Default Method
- **Alt+Shift** - Switch between English and Arabic layouts

### Custom Keybinding
- **Mod+Space** - Alternative toggle (Windows key + Space)

## Testing

1. **Reload i3 config**: Press `Mod+Shift+R`
2. **Switch layout**: Press `Alt+Shift` or `Mod+Space`
3. **Test typing**: Open a text editor and try typing Arabic

## Additional Configuration

### Configure IBus (if installed)
```bash
# Run IBus setup
ibus-setup

# Add Arabic keyboard:
# 1. Go to "Input Method" tab
# 2. Click "Add"
# 3. Select "Arabic" → "Arabic"
# 4. Click "Add"
```

### Configure fcitx5 (if installed)
```bash
# Run fcitx5 config
fcitx5-configtool

# Add Arabic input method
```

### Change Font (if needed)
Edit `~/.config/i3/config` and change the font line:
```ini
font pango:Noto Sans Arabic 10
# or
font pango:Ubuntu 10
```

## Troubleshooting

### Layout not switching?
1. Check if setxkbmap works:
   ```bash
   setxkbmap -layout us,ar -option grp:alt_shift_toggle
   ```
2. Check current layout:
   ```bash
   setxkbmap -query
   ```

### Arabic text not displaying correctly?
1. Install Arabic fonts (see above)
2. Ensure applications use UTF-8 encoding
3. Check font in application settings

### Input method not working?
1. Check if IBus/fcitx5 is running:
   ```bash
   ps aux | grep -E "(ibus|fcitx)"
   ```
2. Restart input method:
   ```bash
   ibus-daemon -drx
   # or
   fcitx5 &
   ```

## Manual Layout Switch

You can manually switch layouts with:
```bash
# Switch to Arabic
setxkbmap ar

# Switch to English
setxkbmap us

# Switch back to both with toggle
setxkbmap -layout us,ar -option grp:alt_shift_toggle
```



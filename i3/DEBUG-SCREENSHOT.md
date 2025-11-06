# Screenshot Debugging Guide

## Quick Test Steps

1. **Test the script manually:**
   ```bash
   ~/.config/i3/scripts/screenshot.sh
   ```

2. **Test with debug mode:**
   Press `Mod4+P` (Windows key + P) to run the debug script

3. **Check the logs:**
   ```bash
   cat /tmp/i3-screenshot.log
   cat /tmp/i3-screenshot-debug.log
   ```

4. **Find the correct key name for PrintScreen:**
   ```bash
   ~/.config/i3/scripts/find-printscreen-key.sh
   ```
   Then press PrintScreen and look for the key name

## Common Issues

### Issue 1: Key binding not recognized
- The PrintScreen key might have a different name
- Try: `xev` and press PrintScreen to see the key name
- Common names: `Print`, `XF86Launch1`, `XF86Tools`, `XF86ScreenSaver`

### Issue 2: No screenshot tool installed
- Install one: `sudo apt install gnome-screenshot` (or flameshot)

### Issue 3: Script not executable
- Fix: `chmod +x ~/.config/i3/scripts/*.sh`

### Issue 4: Path issues
- Scripts now use absolute paths: `/home/taha/.config/i3/scripts/`

## Testing Keybindings

1. Check current bindings:
   ```bash
   i3-msg -t get_config | grep -A 2 screenshot
   ```

2. Reload config:
   ```bash
   i3-msg reload
   ```

3. Test alternative key:
   - Press `Mod4+P` to test if scripts work
   - If Mod4+P works but PrintScreen doesn't, it's a key name issue

## Finding Your PrintScreen Key Name

Run this in a terminal:
```bash
xev | grep -A 2 --line-buffered '^KeyRelease' | sed -n '/keycode /p'
```
Then press PrintScreen and note the keysym name.



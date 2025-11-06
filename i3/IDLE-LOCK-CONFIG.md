# Idle Lock Configuration

## Current Configuration

Your system is now configured to:
- **Keep running** even when idle (no automatic logout)
- **Lock screen after 6 hours** of inactivity (instead of minutes)
- **Keep xss-lock** for suspend/power events (locks when closing laptop lid, etc.)

## What Changed

1. **Added idle lock script** (`~/.config/i3/scripts/disable-idle-lock.sh`)
   - Sets DPMS timeout to 6 hours (21600 seconds)
   - Configures screensaver to 6 hours
   - Disables systemd-logind idle actions

2. **xss-lock still active** - This only locks on:
   - Suspend (laptop lid close)
   - Power events
   - NOT on idle time

## Manual Locking

You can still manually lock your screen:
```bash
# Lock immediately
i3lock

# Or use loginctl
loginctl lock-session
```

## Adjusting the Timeout

To change the 6-hour timeout, edit `~/.config/i3/scripts/disable-idle-lock.sh`:
```bash
# Change this line (6 hours = 21600 seconds)
IDLE_TIMEOUT=21600

# Examples:
# 1 hour = 3600
# 2 hours = 7200
# 12 hours = 43200
# 24 hours = 86400
```

## Completely Disable Locking

If you want to completely disable screen locking (even after 6 hours):

1. **Edit the script** and uncomment these lines:
```bash
# In disable-idle-lock.sh, uncomment:
xset s off
xset s noblank
```

2. **Or comment out xss-lock** in i3 config:
```ini
# exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork
```

## Testing

After reloading i3 config (`Mod+Shift+R`), the computer should:
- Stay unlocked when idle
- Not lock automatically after minutes
- Only lock after 6 hours of inactivity (if configured)

## Troubleshooting

If you still see automatic locking:
1. Check if there are other lock services running:
   ```bash
   ps aux | grep -E "(lock|screensaver)" | grep -v grep
   ```

2. Check systemd-logind settings:
   ```bash
   loginctl show-user $(whoami) | grep IdleAction
   ```

3. Check DPMS settings:
   ```bash
   xset q | grep DPMS
   ```



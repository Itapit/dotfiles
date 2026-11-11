#!/usr/bin/env bash
# waybar/launch.sh — (re)start waybar
# Uses waybar's default paths: ~/.config/waybar/config.jsonc + style.css.
# Skips starting when the bar was hidden with toggle.sh.

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/waybar"

# Single instance of this script at a time
exec 200>"${XDG_RUNTIME_DIR:-/tmp}/waybar-launch.lock"
flock -n 200 || exit 0

pkill -x waybar
# wait (max ~2s) for the old bar to exit so the new one doesn't race it
for _ in $(seq 20); do pgrep -x waybar >/dev/null || break; sleep 0.1; done

if [ -f "$state_dir/disabled" ]; then
    echo ":: Waybar disabled (run toggle.sh to enable)"
    exit 0
fi

# 200>&- : don't let waybar inherit the lock fd. Otherwise the running bar
# holds the lock for its whole life and every later launch.sh / toggle.sh
# exits silently at the flock above (restart and toggle did nothing).
waybar >/dev/null 2>&1 200>&- &
disown

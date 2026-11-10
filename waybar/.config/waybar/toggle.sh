#!/usr/bin/env bash
# waybar/toggle.sh — hide/show the bar; the choice persists across launch.sh runs

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/waybar"
mkdir -p "$state_dir"

if [ -f "$state_dir/disabled" ]; then
    rm "$state_dir/disabled"
else
    touch "$state_dir/disabled"
fi
"$HOME/.config/waybar/launch.sh"

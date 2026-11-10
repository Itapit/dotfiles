#!/bin/bash
# toggle-monitor.sh — toggle the built-in laptop screen on/off (SUPER+SHIFT+S)
# Lua config: `hyprctl keyword` is rejected by the Lua config manager
# ("keyword can't work with non-legacy parsers. Use eval."), so the monitor
# rule is issued as Lua via `hyprctl eval`.

# Target your built-in laptop screen
MONITOR="eDP-1"

# Check if the laptop screen is currently active
if hyprctl monitors | grep -q "Monitor $MONITOR"; then
    # If active, disable it (workspaces move to the external monitor)
    hyprctl eval "hl.monitor({ output = \"$MONITOR\", disabled = true })"
else
    # If disabled, reload config to restore the rule from conf/monitors.lua
    hyprctl reload
fi

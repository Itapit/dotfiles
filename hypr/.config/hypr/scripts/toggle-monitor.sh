#!/bin/bash

# Target your built-in laptop screen
MONITOR="eDP-1"

# Check if the laptop screen is currently active
if hyprctl monitors | grep -q "Monitor $MONITOR"; then
    # If active, disable it and push workspaces to the external monitor
    hyprctl keyword monitor $MONITOR,disable
else
    # If disabled, reload config to turn it back on
    hyprctl reload
fi

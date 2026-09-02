#!/usr/bin/env bash
#    ____         __       ____               __     __
#   /  _/__  ___ / /____ _/ / / __ _____  ___/ /__ _/ /____ ___
#  _/ // _ \(_-</ __/ _ `/ / / / // / _ \/ _  / _ `/ __/ -_|_-<
# /___/_//_/___/\__/\_,_/_/_/  \_,_/ .__/\_,_/\_,_/\__/\__/___/
#                                 /_/
#

# Check if command exists
_checkCommandExists() {
    cmd="$1"
    if ! command -v "$cmd" >/dev/null; then
        echo 1
        return
    fi
    echo 0
    return
}

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

sleep 1
clear
figlet -f smslant "Updates"
echo

if gum confirm "DO YOU WANT TO START THE UPDATE NOW?"; then
    echo
    echo ":: Update started..."
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Update canceled."
    exit
fi

# ----------------------------------------------------- 
# Install update
# ----------------------------------------------------- 

# Arch only
if [[ $(_checkCommandExists "pacman") == 0 ]]; then
    # shellcheck source=/dev/null
    source "$HOME/.config/hypr/conf/config.sh" 2>/dev/null || true
    aur_helper="${aur_helper:-yay}"
    "$aur_helper" -Syu
else
    echo ":: ERROR - Platform not supported (Arch only)"
    echo "Press [ENTER] to close."
    read
fi
echo

# Flatpak
echo ":: Searching for Flatpak updates..."
flatpak update
echo

# Reload Waybar
pkill -RTMIN+1 waybar

# Finishing
echo ":: Update complete! Press [ENTER] to close."
read

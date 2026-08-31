# conf/config.sh — central settings SSOT (edit here, used by both shell and Lua)
# Shell: `source "$HOME/.config/hypr/conf/config.sh"`
# Lua: `local cfg = require("conf.config")` (parses this file, expands $HOME/~)
# Keep format simple: key=value, optional quotes for values with spaces.

# Core apps
terminal=kitty
browser=zen
filemanager=nautilus
editor=code

# Launcher / menus
launcher="rofi -show drun -replace -i"
clipboard="$HOME/.local/bin/cliphist.sh"
wlogout="$HOME/.local/bin/wlogout-menu.sh"

# Paths
hyprscripts="$HOME/.config/hypr/scripts"

# System
aur_helper=yay

# Screenshots (used by scripts/screenshot.sh)
screenshot_folder="$HOME/Pictures/Screenshots"
screenshot_editor=pinta

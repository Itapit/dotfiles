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

# Wallpaper — SSOT. Switch with scripts/set-wallpaper.sh <file> (it updates
# hyprpaper.conf, hyprlock.conf, waypaper ini, blurred png + rofi rasi).
# wallpaper_file is the full filename with extension inside ~/wallpaper.
# default.jpg is the fallback when the configured file is missing.
wallpaper_file=SwissWallpaper.JPG
wallpaper="$HOME/wallpaper/$wallpaper_file"
blurred_wallpaper="$HOME/wallpaper/blurred_wallpaper.png"

# Fonts — general SSOT, rofi_font derives from it
font="JetBrainsMono Nerd Font"
rofi_font="$font"

# Rofi borders — SSOT for all rofi configs
rofi_border_width="3px"
rofi_border_radius="2em"

# Screenshots (used by scripts/screenshot.sh)
screenshot_folder="$HOME/Pictures/Screenshots"
screenshot_editor=pinta

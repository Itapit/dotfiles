#!/usr/bin/env bash
# generate-rofi-wallpaper.sh — generate blurred wallpaper + rofi current_wallpaper.rasi
# Manual run after changing wallpaper_name in conf/config.sh
# Blurred image: $HOME/wallpaper/blurred_wallpaper.png (single file, SSOT: conf/config.sh)
# Rasi shim: rofi/current_wallpaper.rasi next to font.rasi (SSOT: blurred_wallpaper)

set -e

# Source SSOT (shell: wallpaper_name -> wallpaper -> blurred_wallpaper)
# shellcheck source=/dev/null
source "$HOME/.config/hypr/conf/config.sh" 2>/dev/null || true

# Fallbacks if config.sh not yet stowed
wallpaper_name="${wallpaper_name:-SwissWallpaper}"
wallpaper="${wallpaper:-$HOME/wallpaper/$wallpaper_name.JPG}"
blurred_wallpaper="${blurred_wallpaper:-$HOME/wallpaper/blurred_wallpaper.png}"

# If wallpaper path doesn't exist, try common extensions
if [ ! -f "$wallpaper" ]; then
  for ext in JPG jpg png PNG jpeg JPEG; do
    candidate="$HOME/wallpaper/$wallpaper_name.$ext"
    if [ -f "$candidate" ]; then
      wallpaper="$candidate"
      break
    fi
  done
fi

if [ ! -f "$wallpaper" ]; then
  echo "ERROR: wallpaper not found: $wallpaper (wallpaper_name=$wallpaper_name)" >&2
  exit 1
fi

mkdir -p "$(dirname "$blurred_wallpaper")"

# Blur params — matches ML4W blur.sh: 50x30
blur="50x30"

# Prefer magick (ImageMagick 7), fall back to convert (IM6)
if command -v magick >/dev/null 2>&1; then
  magick "$wallpaper" -blur "$blur" "$blurred_wallpaper"
elif command -v convert >/dev/null 2>&1; then
  convert "$wallpaper" -blur "$blur" "$blurred_wallpaper"
else
  echo "ERROR: neither magick nor convert found (install imagemagick)" >&2
  exit 1
fi


echo "Wallpaper: $wallpaper"
echo "Blurred:   $blurred_wallpaper (blur $blur)"

# Rofi configs @import "current_wallpaper.rasi" -> mainbox background-image: @current-image
# Use relative path ../../wallpaper/blurred_wallpaper.png
dotfiles_rasi="$HOME/dotfiles/rofi/.config/rofi/current_wallpaper.rasi"

mkdir -p "$(dirname "$dotfiles_rasi")"
printf '/* Generated from hypr/conf/config.sh — do not edit, run generate-rofi-wallpaper.sh */\n* { current-image: url("../../wallpaper/blurred_wallpaper.png", height); }\n' > "$dotfiles_rasi"

echo "Generated: $dotfiles_rasi"

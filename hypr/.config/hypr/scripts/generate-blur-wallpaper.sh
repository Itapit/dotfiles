#!/usr/bin/env bash
# blur-wallpaper.sh — generate blurred wallpaper for rofi/wlogout
# Manual run after changing wallpaper_name in conf/config.sh
# Saves to $HOME/wallpaper/<name>.blurred.png (SSOT: conf/config.sh)

set -e

# Source SSOT (shell: wallpaper_name -> wallpaper -> blurred_wallpaper)
# shellcheck source=/dev/null
source "$HOME/.config/hypr/conf/config.sh" 2>/dev/null || true

# Fallbacks if config.sh not yet stowed
wallpaper_name="${wallpaper_name:-SwissWallpaper}"
wallpaper="${wallpaper:-$HOME/wallpaper/$wallpaper_name.JPG}"
blurred_wallpaper="${blurred_wallpaper:-$HOME/wallpaper/$wallpaper_name.blurred.png}"

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

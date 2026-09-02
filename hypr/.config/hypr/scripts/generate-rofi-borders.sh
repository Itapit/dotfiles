#!/usr/bin/env bash
# generate-rofi-borders.sh — generate rofi borders.rasi from SSOT conf/config.sh
# SSOT: hypr/conf/config.sh -> rofi_border_width / rofi_border_radius
# Output: dotfiles/rofi/.config/rofi/borders.rasi (stowed as ~/.config/rofi/borders.rasi via stow)
# Run manually after changing rofi_border_* in config.sh

set -e

# Source SSOT
# shellcheck source=/dev/null
source "$HOME/.config/hypr/conf/config.sh" 2>/dev/null || true

# Fallbacks
rofi_border_width="${rofi_border_width:-3px}"
rofi_border_radius="${rofi_border_radius:-2em}"

dotfiles_output="$HOME/dotfiles/rofi/.config/rofi/borders.rasi"

mkdir -p "$(dirname "$dotfiles_output")"
printf '/* Generated from hypr/conf/config.sh — do not edit, run generate-rofi-borders.sh */\n* { border-width: %s; }\n* { border-radius: %s; }\n' "$rofi_border_width" "$rofi_border_radius" > "$dotfiles_output"

echo "Rofi borders: width=$rofi_border_width radius=$rofi_border_radius"
echo "Generated: $dotfiles_output"

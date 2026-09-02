#!/usr/bin/env bash
# generate-rofi-font.sh — generate rofi font.rasi from SSOT conf/config.sh
# SSOT: hypr/conf/config.sh -> font / rofi_font
# Output: ~/.config/rofi/font.rasi (stowed as dotfiles/rofi/.config/rofi/font.rasi)
# Run manually after changing font in config.sh

set -e

# Source SSOT
# shellcheck source=/dev/null
source "$HOME/.config/hypr/conf/config.sh" 2>/dev/null || true

# Fallbacks
font="${font:-JetBrainsMono Nerd Font}"
rofi_font="${rofi_font:-$font}"


dotfiles_output="$HOME/dotfiles/rofi/.config/rofi/font.rasi"

mkdir -p "$(dirname "$output")"
printf '/* Generated from hypr/conf/config.sh — do not edit, run generate-rofi-font.sh */\nconfiguration { font: "%s"; }\n' "$rofi_font" > "$output"

echo "Rofi font: $rofi_font"
echo "Generated: $dotfiles_output"

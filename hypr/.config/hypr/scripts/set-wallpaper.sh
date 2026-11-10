#!/usr/bin/env bash
# set-wallpaper.sh — switch wallpaper (the only supported way)
# Usage: set-wallpaper.sh <filename>   (basename in ~/wallpaper, or full path)
#        set-wallpaper.sh              (print current wallpaper_file and exit)
# Also wired as waypaper's post_command hook (config.ini passes "$wallpaper";
# an optional $monitor 2nd arg is ignored). Re-selecting the current file
# exits early with a note — no regen, no hyprctl calls.
# Updates (all absolute expanded paths, no $HOME leftovers for hypr tools):
#   hypr/conf/config.sh      -> wallpaper_file=<file>
#   hypr/hyprpaper.conf      -> wallpaper { } block        (managed-by-script comment)
#   hypr/hyprlock.conf       -> $wallpaper = ...           (managed-by-script comment)
#   waypaper/config.ini      -> wallpaper = ...            (managed-by-script comment)
# Then regenerates blurred png + rofi rasi via generate-rofi-wallpaper.sh
# and applies the wallpaper live via hyprctl hyprpaper (no compositor reload).
# Missing file -> error suggesting default.jpg (shipped fallback).

set -e

HYPR_DIR="$HOME/.config/hypr"
CONF_SH="$HYPR_DIR/conf/config.sh"
HYPRPAPER="$HYPR_DIR/hyprpaper.conf"
HYPRLOCK="$HYPR_DIR/hyprlock.conf"
WAYPAPER="$HOME/.config/waypaper/config.ini"
REPO_WAYPAPER="$HOME/dotfiles/waypaper/.config/waypaper/config.ini"
WALL_DIR="$HOME/wallpaper"
GENERATOR="$HYPR_DIR/scripts/generate-rofi-wallpaper.sh"

# shellcheck source=/dev/null
source "$CONF_SH" 2>/dev/null || true

if [ $# -eq 0 ]; then
  echo "Current: wallpaper_file=${wallpaper_file:-<unset>} (default.jpg is the fallback)"
  echo "Usage: $(basename "$0") <filename-in-~/wallpaper>"
  exit 0
fi

# Accept basename or full path; always store the basename with extension.
# A second $monitor arg from waypaper's post_command is accepted and ignored.
# NOTE: waypaper passes a shell-escaped path — basenames with spaces need
# unescaping first (none of the shipped wallpapers contain spaces).
input="$1"
file="$(basename "$input")"
src="$WALL_DIR/$file"
[ -f "$input" ] && src="$input" && file="$(basename "$input")"

if [ ! -f "$src" ]; then
  echo "ERROR: wallpaper not found: $src" >&2
  echo "Hint: pick a file from $WALL_DIR, or use default.jpg (shipped fallback)" >&2
  exit 1
fi

# Early-exit: already current (waypaper fires post_command on every select,
# including re-selects and --restore) — skip the magick regen + hyprctl calls.
# Exception: the blurred png is gitignored, so on a fresh clone it is missing
# even though wallpaper_file is already current — generate it then.
if [ "${wallpaper_file:-}" = "$file" ]; then
  if [ ! -f "${blurred_wallpaper:-$WALL_DIR/blurred_wallpaper.png}" ]; then
    echo "Already current: $file, but blurred wallpaper is missing — generating"
    bash "$GENERATOR"
  else
    echo "Already current: $file (nothing to do)"
  fi
  exit 0
fi

abs_path="$WALL_DIR/$file"

# 1. SSOT — point config.sh at the new file (keep other keys untouched)
if grep -q '^wallpaper_file=' "$CONF_SH"; then
  sed -i "s|^wallpaper_file=.*|wallpaper_file=$file|" "$CONF_SH"
else
  printf '\nwallpaper_file=%s\n' "$file" >> "$CONF_SH"
fi

# 2. hyprpaper.conf — hyprpaper needs absolute paths; header marks script ownership.
# hyprpaper >= 0.8.5 ignores the old `preload =` / `wallpaper = ,path` lines
# ("Monitor X has no target: no wp will be created"); it needs a wallpaper
# block. An empty `monitor =` applies to every monitor.
{
  echo "# Managed by set-wallpaper.sh — do not edit the wallpaper block manually"
  echo "wallpaper {"
  echo "    monitor ="
  echo "    path = $abs_path"
  echo "    fit_mode = cover"
  echo "}"
  echo "splash = false"
} > "$HYPRPAPER"

# 3. hyprlock.conf — rewrite only the managed $wallpaper line
if grep -q '^\$wallpaper = ' "$HYPRLOCK"; then
  sed -i "s|^\$wallpaper = .*|\$wallpaper = $abs_path|" "$HYPRLOCK"
else
  echo "WARNING: no '\$wallpaper = ' line in $HYPRLOCK, appending" >&2
  printf '\n# Managed by set-wallpaper.sh — do not edit manually\n$wallpaper = %s\n' "$abs_path" >> "$HYPRLOCK"
fi

# 4. waypaper ini — live path plus repo copy (repo follows via your next commit)
for ini in "$WAYPAPER" "$REPO_WAYPAPER"; do
  if [ -f "$ini" ]; then
    if grep -q '^wallpaper = ' "$ini"; then
      sed -i "s|^wallpaper = .*|wallpaper = ~/wallpaper/$file|" "$ini"
    fi
    grep -q 'Managed by set-wallpaper.sh' "$ini" || \
      sed -i '1i # Managed by set-wallpaper.sh — wallpaper = line is rewritten on switch' "$ini"
    echo "Updated: $ini"
  fi
done

# 5. Blurred png + rofi rasi (reads the just-updated SSOT)
bash "$GENERATOR"

# 6. Apply live (no reload needed). hyprpaper >= 0.8 loads on demand: the
# old `preload` / `unload` IPC requests were removed and now exit non-zero,
# which aborted this script under `set -e`. Only `wallpaper` is needed.
# Non-fatal: config files are already updated, hyprpaper may not be running.
if command -v hyprctl >/dev/null 2>&1; then
  hyprctl hyprpaper wallpaper ",$abs_path" || \
    echo "WARNING: could not apply live (is hyprpaper running?) — applies on next start" >&2
fi

echo "Wallpaper switched to: $file"

#!/usr/bin/env bash
# install.sh — stow the dotfiles into $HOME, backing up whatever is in the way.
#
#   ./install.sh check              dry run: show what would be backed up / linked
#   ./install.sh install [--prune]  back up conflicts, then stow all packages
#   ./install.sh rollback <dir>     unstow and restore a backup made by install
#
# Conflicts are whatever `stow -n` reports (ml4w symlinks, real files that the
# repo now provides). They are MOVED, never deleted, into
#   ~/.local/state/dotfiles-backup/<timestamp>/
# with a manifest, so rollback can put every path back exactly.
#
# --prune also backs up and removes leftover ml4w links (anything in ~ or
# ~/.config pointing into ~/.mydotfiles) and dead links into the old
# ~/dotfiles/.config layout. Links that aren't ml4w (e.g. ~/dots-2.0) stay.
#
# Run it from a TTY with Hyprland NOT running: a live Hyprland watches
# ~/.config/hypr and may regenerate a default hyprland.conf mid-swap.
# --force skips that check.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME"
PACKAGES=(bashrc bin cliphist fastfetch gtk hypr kitty ohmyposh qt rofi swaync
          wallpaper waybar waypaper wlogout)
BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-backup"
ML4W_DIR="$HOME/.mydotfiles"
# Daemons hypr/conf/autostart.lua launches itself. If the same daemon is also
# an enabled systemd user unit, it runs twice (e.g. two stacked waybars).
AUTOSTARTED_UNITS=(waybar.service hyprpaper.service hypridle.service swaync.service)

die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo ":: $*"; }

command -v stow >/dev/null || die "stow is not installed (sudo pacman -S stow)"

# --- helpers ---------------------------------------------------------------

# Paths (relative to $TARGET) that block stowing, one per line, from stow's
# own dry run. Aborts on any conflict type we don't know how to resolve.
stow_conflicts() {
  local out line
  out="$(cd "$DOTFILES" && stow -n -v -t "$TARGET" "${PACKAGES[@]}" 2>&1)" || true
  # Every conflict stow prints is a "  * ..." line. Anything we can't resolve
  # by moving a target aside aborts here — before anything has been touched.
  while IFS= read -r line; do
    case "$line" in
      *"existing target is not owned by stow: "*)
        echo "${line##*existing target is not owned by stow: }" ;;
      *"over existing target "*" since neither a link nor a directory"*)
        line="${line##*over existing target }"
        echo "${line%% since neither a link nor a directory*}" ;;
      "  * "*|*"ERROR"*)
        die "stow problem install.sh can't resolve by backing up: ${line#  \* }" ;;
    esac
  done <<<"$out"
}

# Enabled systemd user units that duplicate our autostart, one per line.
duplicate_units() {
  command -v systemctl >/dev/null || return 0
  local u
  for u in "${AUTOSTARTED_UNITS[@]}"; do
    [ "$(systemctl --user is-enabled "$u" 2>/dev/null)" = "enabled" ] && echo "$u"
  done
  return 0
}

# Leftover links for --prune: into ~/.mydotfiles, or dead links into the old
# ~/dotfiles/.config layout. Printed relative to $TARGET.
prune_candidates() {
  local link dest
  while IFS= read -r link; do
    dest="$(readlink "$link")"
    if [[ "$dest" == "$ML4W_DIR"/* ]] ||
       { [[ "$dest" == "$DOTFILES/.config/"* ]] && [ ! -e "$link" ]; }; then
      echo "${link#"$TARGET"/}"
    fi
  done < <(find "$TARGET" "$TARGET/.config" -maxdepth 1 -type l 2>/dev/null)
}

describe() {  # what is at $TARGET/$1
  local p="$TARGET/$1"
  if [ -L "$p" ]; then echo "link -> $(readlink "$p")"
  elif [ -d "$p" ]; then echo "directory"
  else echo "file"; fi
}

backup_path() {  # move $TARGET/$1 into the backup dir and record it
  local rel="$1"
  mkdir -p "$BACKUP/$(dirname "$rel")"
  mv "$TARGET/$rel" "$BACKUP/$rel"
  printf '%s\n' "$rel" >>"$BACKUP/manifest"
  echo "   backed up: ~/$rel"
}

hyprland_running() { pgrep -x Hyprland >/dev/null 2>&1; }

# --- modes -----------------------------------------------------------------

cmd_check() {
  local conflicts prune
  conflicts="$(stow_conflicts | sort -u)"
  info "Packages: ${PACKAGES[*]}"
  if [ -n "$conflicts" ]; then
    info "Would back up (blocking stow):"
    while IFS= read -r rel; do echo "   ~/$rel  ($(describe "$rel"))"; done <<<"$conflicts"
  else
    info "No conflicts — stow can link everything directly."
  fi
  prune="$(prune_candidates | sort -u | grep -vxF -f <(printf '%s\n' "$conflicts") || true)"
  if [ -n "$prune" ]; then
    info "With --prune, would also back up these leftover links:"
    while IFS= read -r rel; do echo "   ~/$rel  ($(describe "$rel"))"; done <<<"$prune"
  fi
  local units
  units="$(duplicate_units)"
  if [ -n "$units" ]; then
    info "Would disable these systemd user units (autostart.lua already launches them):"
    while IFS= read -r u; do echo "   $u"; done <<<"$units"
  fi
  hyprland_running && echo "NOTE: Hyprland is running — install must be run from a TTY after logging out."
  return 0
}

cmd_install() {
  local prune=0 force=0 arg conflicts round
  for arg in "$@"; do
    case "$arg" in
      --prune) prune=1 ;;
      --force) force=1 ;;
      *) die "unknown option: $arg" ;;
    esac
  done
  if hyprland_running && [ "$force" -eq 0 ]; then
    die "Hyprland is running. Log out, switch to a TTY (Ctrl+Alt+F3) and run this there (or pass --force)."
  fi

  BACKUP="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP"
  : >"$BACKUP/manifest"
  info "Backup dir: $BACKUP"

  # Resolve conflicts until stow's dry run is clean (removing a symlinked dir
  # can only reveal nothing new, but loop defensively).
  for round in 1 2 3 4 5; do
    conflicts="$(stow_conflicts | sort -u)"
    [ -z "$conflicts" ] && break
    [ "$round" -eq 5 ] && die "conflicts remain after 5 rounds:"$'\n'"$conflicts"
    info "Backing up conflicts (round $round):"
    while IFS= read -r rel; do backup_path "$rel"; done <<<"$conflicts"
  done

  if [ "$prune" -eq 1 ]; then
    info "Pruning leftover ml4w / dead links:"
    while IFS= read -r rel; do
      [ -n "$rel" ] && backup_path "$rel"
    done < <(prune_candidates | sort -u)
  fi

  info "Stowing: ${PACKAGES[*]}"
  if ! (cd "$DOTFILES" && stow -v -t "$TARGET" "${PACKAGES[@]}"); then
    echo "ERROR: stow failed — restoring the backup so nothing is left half-installed" >&2
    cmd_rollback "$BACKUP" --force
    exit 1
  fi

  # Units that would double-start what autostart.lua launches (two waybars
  # stacked on top of each other, two hyprpapers). Recorded for rollback.
  local units u
  units="$(duplicate_units)"
  : >"$BACKUP/disabled-units"
  if [ -n "$units" ]; then
    info "Disabling systemd user units that duplicate autostart.lua:"
    while IFS= read -r u; do
      systemctl --user disable --now "$u" >/dev/null 2>&1 &&
        printf '%s\n' "$u" >>"$BACKUP/disabled-units" && echo "   disabled: $u"
    done <<<"$units"
  fi

  # File-manager bookmarks are gitignored (personal paths): carry the old ones over.
  local bm=".config/gtk-3.0/bookmarks"
  # The old gtk-3.0 was backed up as a link (ml4w) or a dir; readlink -f
  # resolves either to the directory that holds bookmarks.
  local old_gtk3 src
  old_gtk3="$(readlink -f "$BACKUP/.config/gtk-3.0" 2>/dev/null || true)"
  src="$old_gtk3/bookmarks"
  if [ ! -e "$TARGET/$bm" ] && [ -n "$old_gtk3" ] && [ -f "$src" ]; then
    cp "$src" "$TARGET/$bm"
    info "Carried over GTK bookmarks from $src"
  fi

  # Blurred wallpaper is gitignored: make sure it exists for rofi/wlogout.
  if [ ! -e "$TARGET/wallpaper/blurred_wallpaper.png" ]; then
    info "Generating blurred wallpaper"
    bash "$TARGET/.config/hypr/scripts/generate-rofi-wallpaper.sh" || echo "WARNING: blur generation failed" >&2
  fi

  if command -v Hyprland >/dev/null; then
    info "Hyprland --verify-config:"
    Hyprland --verify-config 2>&1 | sed -n '/parsing result/,$p' | sed 's/^/   /'
  fi

  info "Done. Rollback with: $0 rollback $BACKUP"
}

cmd_rollback() {
  local dir="${1:-}" rel
  [ -n "$dir" ] || die "usage: $0 rollback <backup-dir>   (dirs in $BACKUP_ROOT)"
  [ -f "$dir/manifest" ] || die "no manifest in $dir"
  if hyprland_running && [ "${2:-}" != "--force" ]; then
    die "Hyprland is running. Run rollback from a TTY (or pass --force after the dir)."
  fi

  info "Unstowing: ${PACKAGES[*]}"
  # non-fatal: after a failed/partial install some packages were never stowed,
  # and the restore below must still run
  (cd "$DOTFILES" && stow -D -v -t "$TARGET" "${PACKAGES[@]}") ||
    echo "WARNING: unstow reported problems — continuing with restore" >&2

  # If stow didn't fold gtk-3.0 into one link, the bookmarks we copied in leave
  # a real ~/.config/gtk-3.0 dir behind that would block restoring the old one.
  local gtk3="$TARGET/.config/gtk-3.0"
  if [ -d "$gtk3" ] && [ ! -L "$gtk3" ] && [ -e "$dir/.config/gtk-3.0" ] &&
     [ "$(ls -A "$gtk3")" = "bookmarks" ]; then
    rm "$gtk3/bookmarks" && rmdir "$gtk3"
  fi

  info "Restoring from $dir"
  tac "$dir/manifest" | while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    if [ -e "$TARGET/$rel" ] || [ -L "$TARGET/$rel" ]; then
      echo "   SKIP (something is there now): ~/$rel"; continue
    fi
    mkdir -p "$TARGET/$(dirname "$rel")"
    mv "$dir/$rel" "$TARGET/$rel"
    echo "   restored: ~/$rel"
  done
  if [ -s "$dir/disabled-units" ]; then
    info "Re-enabling systemd user units install.sh disabled:"
    while IFS= read -r u; do
      [ -n "$u" ] && systemctl --user enable "$u" >/dev/null 2>&1 && echo "   enabled: $u"
    done <"$dir/disabled-units"
  fi
  info "Rollback done."
  # Hyprland >= 0.57 dropped hyprlang: a restored hyprland.conf (e.g. ML4W)
  # won't load unless Hyprland is downgraded too (see README "Rollback").
  if [ -e "$TARGET/.config/hypr/hyprland.conf" ] && [ ! -e "$TARGET/.config/hypr/hyprland.lua" ] &&
     command -v Hyprland >/dev/null; then
    local ver
    ver="$(Hyprland --version 2>/dev/null | sed -n 's/^Hyprland \([0-9.]*\).*/\1/p' | head -1)"
    if [ -n "$ver" ] && [ "$(printf '%s\n0.57\n' "$ver" | sort -V | head -1)" = "0.57" ]; then
      echo "WARNING: restored config is hyprland.conf, but Hyprland $ver can't read it" >&2
      echo "         (hyprlang support ended in 0.57). Downgrade first — see README 'Rollback'." >&2
    fi
  fi
}

case "${1:-}" in
  check)    shift; cmd_check "$@" ;;
  install)  shift; cmd_install "$@" ;;
  rollback) shift; cmd_rollback "$@" ;;
  *) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac

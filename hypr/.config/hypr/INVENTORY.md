# Hypr Inventory — Phase 1 (2026-08-30)

Scope: vendor ML4W deps that live **outside** dotfiles into dotfiles, before Lua migration.
Live system untouched; all edits stay in `dotfiles/` on branch `hypr-lua-migration`.

## Backups

- Internal backup: `hypr/.config/hypr.bak.20260830/` (520K, full copy of `hypr/.config/hypr/` at branch creation).
- Temp backups: `/tmp/hypr-backup-20260830/` and `/tmp/ml4w-backup-20260830/` (read-only reference).
- Git branch: `hypr-lua-migration` from `main` (commit `59c8f43`).
- No `stow` executed; user will validate then `stow -R hypr` manually.

## Vendored apps (new `conf/apps.lua`)

| app | ML4W original (`~/.config/ml4w/settings/*.sh`) | New value per user | Notes |
|---|---|---|---|
| terminal | `terminal.sh` = `kitty` | `kitty` | used in `conf/keybindings/default.conf:12` and `conf/autostart.conf:42` |
| browser | `browser.sh` = `zen-browser` | `zen` | binary name `zen`; fallback `zen-browser` if `zen` missing |
| filemanager | `filemanager.sh` = `nemo` | `nautilus` | replaces nemo |
| editor | `editor.sh` = `gnome-text-editor` | `code` | vscode |
| launcher | n/a | `rofi -show drun -replace -i` | from `keybindings/default.conf:69` |
| clipboard | `~/.config/ml4w/scripts/cliphist.sh` | same path | TODO Phase 2: copy `cliphist.sh` into `dotfiles/bin/.local/bin/` or `hypr/scripts/` to fully decouple |

Hardcoded binds that **stay in keybindings** (not in `apps.lua`): `code` (SUPER+v), `discord` (SUPER+d), `spotify` (SUPER+s), `gitkraken` (SUPER+G), `postman` (SUPER+P), `obsidian` (SUPER+O) — `conf/keybindings/default.conf:17-22`.

## ML4W deps still outside dotfiles (to be handled in Phase 2/3)

- `~/.config/ml4w/listeners.sh --startall` (`conf/autostart.conf:8`) — need to decide to drop or vendor `listeners/gtk-theme-switcher.sh`.
- `~/.config/com.ml4w.hyprlandsettings/hyprctl.sh` (`conf/autostart.conf:35`) — ML4W Settings app live overrides; **delete** in Lua migration.
- `~/.config/ml4w/scripts/{wlogout.sh,sidepad.sh,focus.sh,shell.sh}` referenced in commented binds — already disabled, keep deleted.
- `~/.config/ml4w/settings/{screenshot-*.sh, blur.sh, wallpaper-*.sh, hyprshade.sh, aur.sh}` — wallpaper/automation to be deleted (static wallpaper), screenshot to be simplified.
- `~/.config/ml4w/wallpapers/default.jpg` — not needed (static `~/wallpaper/SwissWallpaper.JPG` per `hyprpaper.conf:1`).
- `~/.cache/ml4w/hyprland-dotfiles/*` — all cache (blurred_wallpaper.png, current_wallpaper, square_wallpaper.png) referenced by `hyprlock.conf:10,21,87` and `scripts/wallpaper*.sh` — replace with static path in Phase 2.
- `bin/.local/bin/{check-updates,install-updates}.sh:45,66` → `aur.sh` — leave for now (waybar deferred).
- Waybar/eww/rofi configs outside dotfiles — **deferred per user**: leave `waybar` alone for now; inventory later.

## Colors

- Current `colors.conf:1` (102 lines, 40+ `rgba(...)` vars including `$primary=rgba(8ecff2ff)`, `$on_primary`, `$surface`, etc.) is **static and good**.
- Decision: move to Lua as `conf/colors.lua` (or inline table in `hyprland.lua`) in Phase 2; **remove autogeneration** from wallpaper pipeline. No more `matugen`/`wallpaper.sh` → `colors.conf` workflow.
- `$color8=$primary` and `$color11=$on_surface` remaps in `hyprland.conf:37-38` will become Lua locals.

## Gamemode

- Per user: delete. Files to remove in Phase 3 cleanup: `scripts/gamemode.sh:9`, `scripts/load-gamemode.sh:20`, `conf/decorations/gamemode.conf`, `conf/windows/gamemode.conf`, commented `keybindings/default.conf:77` bind.

## Wallpaper

- Static: `hyprpaper.conf:1` (`preload` + `wallpaper = ,/home/itapit/wallpaper/SwissWallpaper.JPG`, `splash=false`) — keep.
- Delete in Phase 3: `scripts/wallpaper.sh` (217 lines, sources `ml4w/library.sh`, `wallpaper_cache`, `blur.sh`, `wallpaper-effect.sh`), `wallpaper-restore.sh`, `wallpaper-effects.sh`, `wallpaper-automation.sh`, `wallpaper-cache.sh`, `effects/wallpaper/*` (14 variants).

## Remaining ML4W hits in dotfiles (grep 2026-08-30)

Full `grep -r ml4w` after Phase 1 still shows hits in:
- `hyprland.conf:69` (`source = ~/.config/hypr/conf/ml4w.conf`)
- `conf/ml4w.conf` (4 calendar/sidebar/welcome/settings windowrules, to be pruned)
- `conf/autostart.conf:8,35,42`
- `conf/keybindings/default.conf:9,12-14,65,141,143` (to be rewritten to use `apps.lua`)
- `hyprlock.conf:10,21,87` (cache folder)
- `scripts/*.sh` (7 scripts, most to be deleted or vendored)
- `bin/.local/bin/*.sh` (deferred)

These are intentional for now; Phase 2 (Lua) + Phase 3 (cleanup) will eliminate them. The `.bak.20260830` copies preserve originals.

## Next steps (Phase 2 preview)

1. Ensure `conf/apps.lua` is `require`d from `hyprland.lua` after conversion.
2. Create `conf/colors.lua` from `colors.conf:1`.
3. Convert `hyprland.conf` + each `conf/*.conf` pointer to `*.lua` via `hyprlang2lua`/`hyprmorph` with `--report`.
4. Consolidate pointer files (`conf/monitor.conf:1` etc.) into single `conf/<topic>.lua`.

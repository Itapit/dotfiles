# dotfiles

Arch Linux + Hyprland (Lua config) setup, managed with GNU Stow.
Started life as [ML4W](https://github.com/mylinuxforwork/dotfiles); everything ML4W-specific has been removed or replaced.

## Packages

Each top-level directory is a stow package, mirrored into `$HOME`.

| Package | Provides |
|---|---|
| `hypr` | Hyprland (`hyprland.lua` + `conf/*.lua`), hyprlock, hypridle, hyprpaper, scripts |
| `waybar` | status bar (`config.jsonc`, `modules.json`, `style.css`, `colors.css`) |
| `rofi` | launcher, clipboard, screenshot and confirm menus |
| `swaync` | notification center |
| `wlogout` | power menu |
| `waypaper` | wallpaper picker (calls `set-wallpaper.sh`) |
| `wallpaper` | `~/wallpaper` — shipped wallpapers (other files in `~/wallpaper` are left alone) |
| `kitty` | terminal |
| `bashrc` | `~/.bashrc` |
| `ohmyposh` | prompt theme |
| `fastfetch` | system info banner |
| `cliphist` | clipboard history settings |
| `gtk` | GTK 2/3/4 theme settings (Nordic, Papirus-Dark, Bibata-Modern-Ice) |
| `qt` | qt5ct / qt6ct + Kvantum (Nordic) |
| `bin` | `~/.local/bin` helper scripts |

## Dependencies

Official repos:

```sh
sudo pacman -S --needed \
  hyprland hyprlock hypridle hyprpaper hyprpicker \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk polkit-gnome \
  waybar rofi swaync kitty fastfetch stow \
  grim slurp wl-clipboard cliphist imagemagick jq libnotify gum figlet pacman-contrib \
  brightnessctl playerctl wireplumber libpulse \
  networkmanager network-manager-applet blueman pavucontrol htop nemo \
  qt5ct qt6ct kvantum kvantum-qt5 papirus-icon-theme \
  ttf-jetbrains-mono-nerd ttf-fira-sans otf-font-awesome
```

AUR:

```sh
yay -S --needed grimblast-git wlogout waypaper checkupdates-with-aur \
  nordic-theme bibata-cursor-theme-bin oh-my-posh-bin
```

Apps referenced by keybinds/autostart (`hypr/.config/hypr/conf/config.sh`, `keybindings.lua`, `autostart.lua`) — install what you use:
`zen-browser-bin` `visual-studio-code-bin` `gitkraken` `spotify` `postman-bin` (AUR), `discord` `obsidian` `pinta` (repos).
Optional: `nwg-look` `nwg-displays` (window rules exist for them), `flatpak` (`install-updates.sh` also updates flatpaks), `tree` `cloc` (`tree-gitignore.sh`).

## Install

The repo must live at `~/dotfiles` (some scripts write generated files back into it).

```sh
git clone <repo> ~/dotfiles
cd ~/dotfiles
./install.sh check              # dry run: lists what would be backed up / pruned
```

Then **log out of Hyprland**, switch to a TTY (`Ctrl+Alt+F3`), log in and run:

```sh
~/dotfiles/install.sh install --prune
```

- Anything in the way of a stow link (old ML4W symlinks, real config files) is **moved** to
  `~/.local/state/dotfiles-backup/<timestamp>/`, never deleted.
- `--prune` also moves leftover ML4W links (anything pointing into `~/.mydotfiles`) and dead links
  from the old `~/dotfiles/.config` layout. Unrelated links are not touched.
- Your GTK file-manager bookmarks are carried over; the blurred wallpaper is generated if missing.
- systemd user units for daemons `autostart.lua` already launches (waybar, hyprpaper, hypridle,
  swaync) are disabled so they don't start twice; rollback re-enables them.
- It finishes with `Hyprland --verify-config` on the stowed config.
- Running it inside a Hyprland session is refused: the live compositor watches `~/.config/hypr`.

Log back in (start Hyprland as usual) when it reports `config ok`.

### Rollback

```sh
~/dotfiles/install.sh rollback ~/.local/state/dotfiles-backup/<timestamp>
```

Unstows every package and moves each backed-up path back where it was.
If the final `stow` of an install fails, the script rolls back automatically.

> **Hyprland ≥ 0.57 no longer reads `hyprland.conf` (hyprlang).** Restoring an old
> hyprlang config (e.g. the ML4W one) only gives a working session on ≤ 0.56. To fully go
> back, also downgrade from the pacman cache (versions this machine ran before 0.57):
>
> ```sh
> cd /var/cache/pacman/pkg && sudo pacman -U \
>   hyprland-0.56.2-1-x86_64.pkg.tar.zst aquamarine-0.14.0-2-x86_64.pkg.tar.zst \
>   hyprutils-0.14.1-1-x86_64.pkg.tar.zst hyprgraphics-0.5.1-4-x86_64.pkg.tar.zst \
>   hyprcursor-0.1.13-7-x86_64.pkg.tar.zst hyprtoolkit-0.5.4-4-x86_64.pkg.tar.zst \
>   hyprland-guiutils-0.2.2-2-x86_64.pkg.tar.zst
> ```
>
> and add `hyprland` to `IgnorePkg` in `/etc/pacman.conf` until you're ready to move forward again.

## How it fits together

- **`hypr/.config/hypr/conf/config.sh` is the single source of truth** for apps (terminal, browser,
  file manager…), the status bar command, wallpaper, fonts and rofi borders. Shell scripts `source`
  it; `conf/config.lua` parses it for Hyprland.
- **Wallpaper:** change it with `~/.config/hypr/scripts/set-wallpaper.sh <file>` or waypaper. It updates
  `config.sh`, `hyprpaper.conf`, `hyprlock.conf`, waypaper's ini, the blurred copy used by rofi/wlogout,
  and applies it live. Those files are tracked, so a wallpaper change shows up in `git status`.
- **Colors** are a static Material palette kept in sync by hand across `hypr/conf/colors.lua`,
  `hypr/colors.conf` (hyprlock), `rofi/colors.rasi`, `waybar/colors.css` and `gtk-3.0/colors.css`.
  swaync and kitty use Nord.
- **Hyprland Lua config:** `hyprctl dispatch` takes a Lua dispatcher, e.g.
  `hyprctl dispatch 'hl.dsp.dpms({ action = "off" })'` — the old `hyprctl dispatch dpms off` form and
  `hyprctl keyword` are rejected. Check the config with
  `Hyprland --verify-config -c ~/.config/hypr/hyprland.lua`.
- **Rofi scripts:** `hypr/scripts/generate-rofi-{font,borders,wallpaper}.sh` regenerate the rofi
  `.rasi` snippets from `config.sh`.

## Keybinds

`SUPER` is the main modifier.

| Keys | Action |
|---|---|
| `T` / `B` / `F` | terminal / browser / file manager |
| `V` `D` `S` `G` `P` `O` | VS Code, Discord, Spotify, GitKraken, Postman, Obsidian |
| `A` | app launcher (rofi) |
| `SHIFT V` | clipboard history |
| `SHIFT L` | power menu (wlogout) |
| `Q` | close window |
| `SHIFT F` | fullscreen |
| `CTRL SHIFT F` | float / tile every window on the workspace |
| `Tab` | cycle windows |
| `1`–`0` / `SHIFT 1`–`0` | switch to / move window to workspace |
| `SHIFT S` | toggle laptop screen (eDP-1) |
| `CTRL R` | reload Hyprland |
| `PRINT` / `SHIFT PRINT` | area screenshot to clipboard / screenshot menu |
| mouse left / right drag | move / resize window |

-- conf/apps.lua — centralized application definitions
-- Vendored from ~/.config/ml4w/settings/* (Phase 1 inventory 2026-08-30)
-- Original ML4W files: terminal.sh=kitty, browser.sh=zen-browser, filemanager.sh=nemo, editor.sh=gnome-text-editor
-- Per user request: terminal=kitty, browser=zen, filemanager=nautilus, editor=code
-- This module will be required by hyprland.lua and keybindings.lua after Lua migration.
-- Waybar/eww theming intentionally left out (dealt with later).

local apps = {
  terminal    = "kitty",
  browser     = "zen",          -- zen-browser package; binary `zen` (fallback: zen-browser)
  filemanager = "nautilus",
  editor      = "code",         -- vscode

  -- Launcher / menus
  launcher    = "rofi -show drun -replace -i",
  clipboard   = "~/.config/ml4w/scripts/cliphist.sh", -- TODO: vendor or replace with cliphist.sh inside dotfiles/bin
}

return apps

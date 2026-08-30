-- hyprland.lua — Hyprland 0.56 Lua config (migrated 2026-08-30)
-- Entry point. Modular requires mirror old hyprland.conf source tree, but collapsed.
-- Branch: hypr-lua-migration. Original hyprland.conf kept as hyprland.conf.bak.20260830.
-- See INVENTORY.md and conf/*.lua for per-module docs.

-- Colors first (defines palette, no Hyprland calls)
require("conf.colors")

-- Core hardware / input
require("conf.monitors")
require("conf.input")
require("conf.cursor")
require("conf.environment")

-- Look & feel
require("conf.general")
require("conf.decoration")
require("conf.layout")
require("conf.misc")
require("conf.animations")

-- Rules
require("conf.windowrules")

-- Autostart (exec-once etc.) — must come after env
require("conf.autostart")

-- Keybindings last (uses conf.apps)
require("conf.keybindings")

-- Optional: load custom overrides if file exists
-- pcall(require, "conf.custom")

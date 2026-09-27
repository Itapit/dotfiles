-- hyprland.lua — Hyprland 0.56 Lua entry point
-- https://wiki.hypr.land/Configuring/Start/
-- Each module is a Lua file under conf/. Order matters: palette first, then
-- hardware/input, look & feel, rules, autostart (after env), keybindings last.

-- Palette — no Hyprland calls, just color table for other modules
require("conf.colors")

-- Hardware & input
require("conf.monitors")    -- https://wiki.hypr.land/Configuring/Basics/Monitors/
require("conf.input")       -- https://wiki.hypr.land/Configuring/Variables/#input
require("conf.cursor")      -- cursor theme/size
require("conf.environment") -- env vars + xwayland

-- Look & feel
require("conf.general")     -- gaps, borders, layout
require("conf.decoration")  -- rounding, blur, shadow + waybar layer rules
require("conf.layout")      -- dwindle, binds, gestures
require("conf.misc")        -- logo, splash, workspace tracking
require("conf.animations")  -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

-- Rules
require("conf.windowrules") -- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Autostart — must come after environment
require("conf.autostart")   -- https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Keybindings — uses conf/apps.lua
require("conf.keybindings") -- https://wiki.hypr.land/Configuring/Basics/Binds/

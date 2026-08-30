-- conf/keybindings.lua — migrated from conf/keybindings/default.conf (2026-08-30)
-- Uses conf/apps.lua for terminal/browser/filemanager. Case is intentional:
-- Hyprland binds are case-sensitive (SUPER+T = SUPER+SHIFT+t). Original kept
-- T/B/F uppercase for primary apps and v/d/s lowercase for secondary; preserved here.
-- Dispatchers: native hl.dsp.* where available (window.kill/fullscreen, focus,
-- window.move/drag/resize); cyclenext/reload have no typed dispatcher in 0.56
-- stubs, so we fallback to hyprctl via exec_cmd (documented below).

local apps = require("conf.apps")

local mainMod = "SUPER"
local hyprscripts = os.getenv("HOME") .. "/.config/hypr/scripts"

-- Applications
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(apps.terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(apps.browser))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(apps.filemanager))
hl.bind(mainMod .. " + v", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + d", hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + s", hl.dsp.exec_cmd("spotify"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("gitkraken"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("postman"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian"))

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(hyprscripts .. "/toggle-monitor.sh"))

-- Windows
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 0 }))
-- cyclenext has no hl.dsp typed dispatcher in 0.56 stubs → shell fallback (cost: one hyprctl fork per Tab)
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch cyclenext"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Actions
-- reload has no hl.dsp typed dispatcher in 0.56 → hyprctl fallback
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd(hyprscripts .. "/screenshot.sh"))
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast --notify copy area"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/ml4w/scripts/wlogout.sh")) -- TODO: vendor wlogout.sh out of ml4w if you keep wlogout
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -replace -i"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(hyprscripts .. "/../bin/cliphist.sh")) -- original $SCRIPTS/cliphist.sh; prefer hypr/scripts or bin path — adjust

-- Workspaces: 1-10 (0 maps to 10)
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Fn keys
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -q s +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"))
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),     { repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl pause"))
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
-- hl.bind("XF86Lock",              hl.dsp.exec_cmd("hyprlock")) -- disabled: Unknown keysym on 0.56, use loginctl or keep original hyprlang if needed

hl.bind("code:238", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"))
hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"))

-- Dropped/calc: XF86Calculator and XF86Tools (ML4W settings app) — uncomment if needed:
-- hl.bind("XF86Calculator", hl.dsp.exec_cmd("qalculate-gtk"))
-- hl.bind("XF86Tools",      hl.dsp.exec_cmd("flatpak run com.ml4w.settings"))

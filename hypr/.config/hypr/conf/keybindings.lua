-- conf/keybindings.lua — keybindings (SUPER = mainMod)
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- Case is intentional: SUPER+T is SHIFT+t. T/B/F are uppercase (with SHIFT),
-- v/d/s are lowercase. Dispatchers use native hl.dsp.* where available;
-- cyclenext/reload have no typed dispatcher in 0.56, fallback to hyprctl.

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
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())                           -- close focused window
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 0 })) -- fullscreen active window
-- Tab cycles windows (no typed dsp in 0.56 → hyprctl fallback)
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch cyclenext"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Actions
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"))               -- reload config (no typed dsp in 0.56)
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd(hyprscripts .. "/screenshot.sh")) -- screenshot menu
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast --notify copy area"))                  -- area screenshot
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/ml4w/scripts/wlogout.sh")) -- TODO: vendor wlogout.sh out of ml4w if you keep wlogout
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -replace -i")) -- rofi launcher
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(apps.clipboard)) -- clipboard history (bin/.local/bin via apps.lua)

-- Workspaces 1-10 (0 → 10)
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))       -- switch to ws
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i })) -- move window to ws
end

-- Media / brightness keys (all wpctl for WirePlumber uniformity)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -q s +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"))
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),     { repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))        -- sink mute
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl pause"))
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")) -- mic mute

-- Keyboard backlight (Apple SMC)
hl.bind("code:238", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"))
hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"))

-- Optional: calculator / settings (uncomment if you use them)
-- hl.bind("XF86Calculator", hl.dsp.exec_cmd("qalculate-gtk"))
-- hl.bind("XF86Tools",      hl.dsp.exec_cmd("flatpak run com.ml4w.settings"))

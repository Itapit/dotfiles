-- conf/autostart.lua — autostart daemons and workspace apps
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- All commands run once on Hyprland start. dbus env is exported first so
-- portals and bars inherit WAYLAND_DISPLAY/XDG_CURRENT_DESKTOP.

local apps = require("conf.apps")
local home = os.getenv("HOME")

hl.on("hyprland.start", function()
  -- System env for Wayland portals
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- Core daemons
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1") -- auth agent for sudo/polkit
  hl.exec_cmd("swaync")                                                     -- notification center
  hl.exec_cmd("hypridle")                                                   -- idle daemon (→ hyprlock)
  hl.exec_cmd("wl-paste --watch cliphist store")                            -- clipboard history
  hl.exec_cmd(home .. "/.config/hypr/scripts/gtk.sh")                       -- sync GTK theme/cursor from settings.ini
  hl.exec_cmd("hyprpaper")                                                   -- wallpaper daemon (reads hyprpaper.conf)

  -- Workspace apps (silent — open in background)
  hl.exec_cmd("[workspace 1 silent] " .. apps.editor)   -- ws 1
  hl.exec_cmd("[workspace 2 silent] " .. apps.browser)  -- ws 2
  hl.exec_cmd("[workspace 4 silent] gitkraken")         -- ws 4
  hl.exec_cmd("[workspace 5 silent] spotify")           -- ws 5
  hl.exec_cmd("[workspace 3 silent] " .. apps.terminal) -- ws 3
end)

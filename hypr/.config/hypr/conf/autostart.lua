-- conf/autostart.lua — autostart (from conf/autostart.conf, decoupled from ML4W)
-- Dropped: ~/.config/ml4w/listeners.sh --startall, ~/.config/com.ml4w.hyprlandsettings/hyprctl.sh
-- Kept: polkit, swaync, hypridle, cliphist, cleanup, workspace apps
-- Note: single hl.on block ensures dbus env is exported before apps that need it.

local apps = require("conf.apps")
local home = os.getenv("HOME")

hl.on("hyprland.start", function()
  -- Export Wayland env to systemd/dbus first (was separate hl.on — now merged to avoid race)
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("swaync")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd(home .. "/.config/hypr/scripts/gtk.sh")
  hl.exec_cmd(home .. "/.config/hypr/scripts/cleanup.sh")
  -- wallpaper is handled by hyprpaper (see hyprpaper.conf), no wallpaper-restore.sh needed

  -- Workspace apps (silent) — use apps.lua vars for terminal/browser/editor
  hl.exec_cmd("[workspace 1 silent] " .. apps.editor)
  hl.exec_cmd("[workspace 2 silent] " .. apps.browser)
  hl.exec_cmd("[workspace 4 silent] gitkraken")
  hl.exec_cmd("[workspace 5 silent] spotify")
  hl.exec_cmd("[workspace 3 silent] " .. apps.terminal)
end)

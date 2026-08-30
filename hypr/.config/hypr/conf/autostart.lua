-- conf/autostart.lua — autostart (from conf/autostart.conf, decoupled from ML4W)
-- Dropped: ~/.config/ml4w/listeners.sh --startall, ~/.config/com.ml4w.hyprlandsettings/hyprctl.sh
-- Kept: polkit, swaync, hypridle, cliphist, cleanup, workspace apps

hl.on("hyprland.start", function()
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("swaync")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("wl-paste --watch cliphist store")
  hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")
  hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")
  -- wallpaper is handled by hyprpaper (see hyprpaper.conf), no wallpaper-restore.sh needed for static wallpaper

  -- Workspace apps (silent)
  hl.exec_cmd("[workspace 1 silent] code")
  hl.exec_cmd("[workspace 2 silent] zen")
  hl.exec_cmd("[workspace 4 silent] gitkraken")
  hl.exec_cmd("[workspace 5 silent] spotify")
  hl.exec_cmd("[workspace 3 silent] kitty")
end)

-- dbus environment — original was `exec-once=dbus-update-activation...` (no hyprctl wrapper)
hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

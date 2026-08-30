-- conf/environment.lua — Wayland session + toolkit env vars and xwayland
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- XDG/QT/GDK set the Wayland backend; MOZ/OZONE force Electron/Firefox native Wayland.

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct") -- qt6ct for qt6; use qt5ct for qt5
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("GDK_SCALE", "1") -- GTK scale
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("MOZ_ENABLE_WAYLAND", "1") -- Firefox Wayland

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("OZONE_PLATFORM", "wayland") -- Chromium/Electron ozone
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

hl.env("SDL_VIDEODRIVER", "wayland") -- SDL Wayland

hl.config({
  xwayland = {
    force_zero_scaling = true, -- no scaling for XWayland windows
  },
})

-- conf/environment.lua — env vars + xwayland (from conf/ml4w.conf:152-185 + conf/custom.conf SDL)
-- Default Settings note in conf/environments/default.conf is now materialized here.

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- duplicate line in original: qt5ct — keep only qt6ct (relevant for qt6); if you need qt5ct, swap manually
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("GDK_SCALE", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("OZONE_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

hl.env("SDL_VIDEODRIVER", "wayland")

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

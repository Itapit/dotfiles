-- conf/windowrules.lua — floating, tiling, idle-inhibit, and layer blur
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/ and Layerrules
-- Each rule matches a window/layer and applies properties (float, pin, blur, etc.).

-- Tiling / idle
hl.window_rule({ name = "Chromium-tile",        match = { title = "^Chromium$" }, tile = true })
hl.window_rule({ name = "idleinhibit-fullscreen", idle_inhibit = "fullscreen" }) -- prevent idle while fullscreen video

-- Floating helpers (file managers, calculators)
hl.window_rule({ name = "pavucontrol-float",    match = { title = "^pavucontrol$" }, float = true })
hl.window_rule({ name = "blueman-float-title",  match = { title = "^blueman-manager$" }, float = true })
hl.window_rule({ name = "nm-editor-float",      match = { title = "^nm-connection-editor$" }, float = true })
hl.window_rule({ name = "qalculate-float",      match = { title = "^qalculate-gtk$" }, float = true })
hl.window_rule({ name = "pip", match = { title = "^Picture-in-Picture$" }, float = true, pin = true, move = "69.5% 4%" }) -- PiP browser video
hl.window_rule({ name = "resolve-no-blur",       match = { class = "^resolve$", xwayland = true }, no_blur = true }) -- DaVinci Resolve XWayland fix

-- App-specific floating with size/position
hl.window_rule({ name = "pavucontrol-org", match = { class = ".*org.pulseaudio.pavucontrol.*" }, float = true, size = "700 600", center = true, pin = true })
hl.window_rule({ name = "waypaper",         match = { class = ".*waypaper.*" },                 float = true, size = "900 700", center = true, pin = true })
hl.window_rule({ name = "blueman-manager", match = { class = "^blueman-manager$" }, float = true, size = "800 600", center = true })
hl.window_rule({ name = "nwg-look",        match = { class = "nwg-look" },           float = true, size = "700 600", move = "10% 20%", pin = true })
hl.window_rule({ name = "nwg-displays",    match = { class = "nwg-displays" },       float = true, size = "900 600", move = "10% 20%", pin = true })
hl.window_rule({ name = "missioncenter",          match = { class = "io.missioncenter.MissionCenter" }, float = true, pin = true, center = true, size = "900 600" })
hl.window_rule({ name = "missioncenter-prefs",    match = { class = "missioncenter", title = "^Preferences$" }, float = true, pin = true, center = true })
hl.window_rule({ name = "hyprland-share-picker",  match = { class = "hyprland-share-picker" }, float = true, pin = true, center = true, size = "600 400" })
hl.window_rule({ name = "dotfiles-floating", match = { class = "dotfiles-floating" }, float = true, size = "1000 700", center = true })
hl.window_rule({ name = "xdg-portal", match = { class = "^xdg-desktop-portal-gtk$", title = "^(Open.*Files?|Save.*Files?|All Files|Save)$" }, float = true, center = true }) -- GTK open/save dialogs

-- Layer blur for notifications and bar
hl.layer_rule({ name = "swaync-control-center",   match = { namespace = "swaync-control-center" },     blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ name = "swaync-notification",     match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.5 })

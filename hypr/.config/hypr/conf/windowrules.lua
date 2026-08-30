-- conf/windowrules.lua — window/layer rules (from conf/windowrules/default.conf + filtered conf/ml4w.conf)
-- Kept: pavucontrol, blueman, waypaper, swaync, nwg-look/displays, Mission Center, share picker, generic floating + file picker.
-- Dropped: Newelle, com.ml4w.calendar/sidebar/welcome/settings, dotfiles-sidepad (ML4W).
-- Original hyprlang `windowrule = match:...` → hl.window_rule / hl.layer_rule

-- Generic: idle inhibit + Chromium tile
hl.window_rule({ name = "Chromium-tile",        match = { title = "^Chromium$" }, tile = true })
hl.window_rule({ name = "pavucontrol-float",    match = { title = "^pavucontrol$" }, float = true })
hl.window_rule({ name = "blueman-float-title",  match = { title = "^blueman-manager$" }, float = true })
hl.window_rule({ name = "nm-editor-float",      match = { title = "^nm-connection-editor$" }, float = true })
hl.window_rule({ name = "qalculate-float",      match = { title = "^qalculate-gtk$" }, float = true })

hl.window_rule({ name = "pip-float", match = { title = "^Picture-in-Picture$" }, float = true })
hl.window_rule({ name = "pip-pin",   match = { title = "^Picture-in-Picture$" }, pin = true })
hl.window_rule({ name = "pip-move",  match = { title = "^Picture-in-Picture$" }, move = "69.5% 4%" })

hl.window_rule({ name = "idleinhibit-fullscreen", match = { class = "^.*$" }, idle_inhibit = "fullscreen" })
hl.window_rule({ name = "resolve-no-blur",       match = { class = "^resolve$", xwayland = true }, no_blur = true })

-- ML4W-legacy but still useful (keep minimal)
hl.window_rule({ name = "pavucontrol-org", match = { class = ".*org.pulseaudio.pavucontrol.*" }, float = true, size = "700 600", center = true, pin = true })
hl.window_rule({ name = "waypaper",         match = { class = ".*waypaper.*" },                 float = true, size = "900 700", center = true, pin = true })

hl.layer_rule({ name = "swaync-control-center",   match = { namespace = "swaync-control-center" },     blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ name = "swaync-notification",     match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.5 })

hl.window_rule({ name = "blueman-manager", match = { class = "^blueman-manager$" }, float = true, size = "800 600", center = true })
hl.window_rule({ name = "nwg-look",        match = { class = "nwg-look" },           float = true, size = "700 600", move = "10% 20%", pin = true })
hl.window_rule({ name = "nwg-displays",    match = { class = "nwg-displays" },       float = true, size = "900 600", move = "10% 20%", pin = true })

hl.window_rule({ name = "missioncenter",          match = { class = "io.missioncenter.MissionCenter" }, float = true, pin = true, center = true, size = "900 600" })
hl.window_rule({ name = "missioncenter-prefs",    match = { class = "missioncenter", title = "^Preferences$" }, float = true, pin = true, center = true })

hl.window_rule({ name = "hyprland-share-picker",  match = { class = "hyprland-share-picker" }, float = true, pin = true, center = true, size = "600 400" })

hl.window_rule({ name = "dotfiles-floating", match = { class = "dotfiles-floating" }, float = true, size = "1000 700", center = true })

-- File pickers
hl.window_rule({ name = "xdg-portal-open", match = { class = "^xdg-desktop-portal-gtk$", title = "^(Open.*Files?|Save.*Files?|All Files|Save)$" }, float = true })
hl.window_rule({ name = "xdg-portal-center", match = { class = "^xdg-desktop-portal-gtk$", title = "^(Open.*Files?|Save.*Files?|All Files|Save)$" }, center = true })

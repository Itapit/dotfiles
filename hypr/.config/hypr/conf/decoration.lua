-- conf/decoration.lua — window decoration (from conf/decorations/default.conf + conf/custom.conf)
-- Name: "Rounding All Blur No Shadows" + waybar layerrule from custom.conf

hl.config({
  decoration = {
    rounding         = 10,
    active_opacity   = 1.0,
    inactive_opacity = 0.9,
    blur = {
      enabled        = true,
      size           = 12,
      passes         = 4,
      ignore_opacity = true,
      xray           = true,
    },
    shadow = {
      enabled      = true,
      range        = 10,
      render_power = 2,
      color        = "rgba(00000033)",
    },
  },
})

-- Keep waybar/waybar blur rules
hl.layer_rule({ name = "waybar-blur",     match = { namespace = "^waybar$" }, blur = true })
hl.layer_rule({ name = "waybar-alpha",    match = { namespace = "^waybar$" }, ignore_alpha = 0.1 })
hl.layer_rule({ name = "custom-waybar-blur", match = { namespace = "^waybar$" }, blur = true }) -- from custom.conf layerrule
-- Note: exact hl.layer_rule keys for ignore_alpha may be `ignore_alpha`; keep as in 0.56 stubs.

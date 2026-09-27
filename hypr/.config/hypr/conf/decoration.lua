-- conf/decoration.lua — rounding, blur, shadow, and opacity
-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- Blur xray + ignore_opacity keeps panels readable; shadow adds depth

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

-- Waybar layer — blur behind bar for transparency
hl.layer_rule({ name = "waybar-blur",  match = { namespace = "^waybar$" }, blur = true })
hl.layer_rule({ name = "waybar-alpha", match = { namespace = "^waybar$" }, ignore_alpha = 0.1 })

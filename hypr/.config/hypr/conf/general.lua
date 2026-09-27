-- conf/general.lua — gaps, borders, and layout
-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- gaps_in/out: spacing, border_size + col.*_border: focused vs unfocused highlight

local colors = require("conf.colors")

hl.config({
  general = {
    gaps_in          = 3,
    gaps_out         = 8,
    border_size      = 2,
    ["col.active_border"]   = colors.primary,        -- vibrant accent for focused window
    ["col.inactive_border"] = colors.outline_variant, -- muted for unfocused
    layout           = "dwindle",
    resize_on_border = true,
  },
})

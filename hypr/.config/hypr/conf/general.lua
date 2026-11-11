-- conf/general.lua — gaps, borders, and layout
-- https://wiki.hypr.land/configuring/core/config-options/#general
-- gaps_in/out: spacing, border_size + col.*_border: focused vs unfocused highlight

local colors = require("conf.colors")

hl.config({
  general = {
    gaps_in          = 3,
    gaps_out         = 8,
    -- 0 = no window border, as in the old ml4w setup (its custom.conf set 0).
    -- For a subtle one instead: border_size = 1 with active_border = colors.outline.
    border_size      = 0,
    ["col.active_border"]   = colors.primary,        -- focused window (only visible if border_size > 0)
    ["col.inactive_border"] = colors.outline_variant, -- unfocused
    layout           = "dwindle",
    resize_on_border = true,
  },
})

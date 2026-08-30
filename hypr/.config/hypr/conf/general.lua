-- conf/general.lua — general window layout (from conf/windows/default.conf + conf/custom.conf)
-- Picked: border_size=2 with correct hierarchy (active=primary vibrant, inactive=muted).
-- Previously custom.conf had border_size=0 (cols were no-ops) and inverted
-- colors (active=$on_surface muted, inactive=$primary accent). Now fixed.

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

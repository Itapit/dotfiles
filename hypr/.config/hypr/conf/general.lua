-- conf/general.lua — general window layout (from conf/windows/default.conf + conf/custom.conf override)
-- Custom override had border_size=0, gaps_in=3, gaps_out=8 — kept as user preference.
-- Default was gaps_in=10, gaps_out=20, border_size=3, col.*=$color11/$color8.

local colors = require("conf.colors")

hl.config({
  general = {
    gaps_in          = 3,
    gaps_out         = 8,
    border_size      = 0,
    ["col.active_border"]   = colors.color11, -- $color11 = $on_surface
    ["col.inactive_border"] = colors.color8,  -- $color8  = $primary
    layout           = "dwindle",
    resize_on_border = true,
  },
})

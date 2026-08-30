-- conf/monitors.lua — monitor layout
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Edit output/mode/position/scale for your setup. nwg-displays writes to this file format.

hl.monitor({
  output   = "eDP-1",
  mode     = "1920x1080@60.03",
  position = "2560x0",
  scale    = 1.0,
})

hl.monitor({
  output   = "HDMI-A-1",
  mode     = "2560x1440@60.0",
  position = "0x0",
  scale    = 1.0,
})

-- Fallback for any unlisted monitor:
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- conf/monitors.lua — monitor layout (migrated from monitors.conf + conf/monitors/default.conf)
-- Static config: eDP-1 (laptop) + HDMI-A-1 (external). Edit here for your setup.
-- Fallback "preferred,auto,1" is not needed when explicit monitors are defined.

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

-- Fallback for any other monitor not explicitly listed:
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.0 })

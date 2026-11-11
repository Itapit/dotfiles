-- conf/cursor.lua — cursor theme and size
-- https://wiki.hypr.land/configuring/core/config-options/#cursor

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
end)

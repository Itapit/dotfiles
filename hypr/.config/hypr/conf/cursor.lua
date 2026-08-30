-- conf/cursor.lua — cursor (from conf/cursor.conf)
-- Original: exec-once = hyprctl setcursor Bibata-Modern-Ice 24

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
end)

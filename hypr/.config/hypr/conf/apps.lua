-- conf/apps.lua — central app definitions
-- Edit here to change your default apps; referenced by autostart.lua and keybindings.lua.
-- https://wiki.hypr.land/Configuring/Basics/Autostart/ and Binds

local apps = {
  terminal    = "kitty",                       -- terminal emulator
  browser     = "zen",                         -- zen-browser, binary is `zen` (fallback: zen-browser)
  filemanager = "nautilus",                    -- file manager (GNOME Files)
  editor      = "code",                        -- VS Code (`code` binary)

  -- Launcher / menus
  launcher    = "rofi -show drun -replace -i", -- app launcher (SUPER+A)
  clipboard   = "~/.config/ml4w/scripts/cliphist.sh", -- TODO: vendor to dotfiles/bin/.local/bin or hypr/scripts/
}

return apps

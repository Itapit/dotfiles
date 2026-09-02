-- conf/config.lua — central settings (parses conf/config.sh as SSOT)
-- SSOT is conf/config.sh — edit there. This parser keeps shell and Lua in sync.
-- https://wiki.hypr.land/Configuring/Basics/Autostart/ and Binds

local home = os.getenv("HOME") -- separate local, not part of returned table

local function parse_config_sh(path)
  local cfg = {}
  local f = io.open(path, "r")
  if not f then return cfg end
  for line in f:lines() do
    -- skip empty and comments
    if not line:match("^%s*#") and not line:match("^%s*$") then
      local k, v = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
      if k and v then
        -- strip surrounding quotes if any
        v = v:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
        -- expand $HOME and ~
        v = v:gsub("%$HOME", home):gsub("^~", home)
        cfg[k] = v
      end
    end
  end
  f:close()
  -- second pass: expand $var / ${var} referencing other keys in the same file
  -- (e.g., wallpaper="$HOME/wallpaper/$wallpaper_name.JPG")
  for _ = 1, 2 do
    for k, v in pairs(cfg) do
      v = v:gsub("%$%{([%w_]+)%}", function(var) return cfg[var] or ("${" .. var .. "}") end)
      v = v:gsub("%$([%w_]+)", function(var)
        if var == "HOME" then return home end
        return cfg[var] or ("$" .. var)
      end)
      cfg[k] = v
    end
  end
  return cfg
end

local config = parse_config_sh(home .. "/.config/hypr/conf/config.sh")

-- Fallbacks if file missing/parse failed (keep Hyprland bootable)
config.terminal    = config.terminal    or "kitty"
config.browser     = config.browser     or "zen"
config.filemanager = config.filemanager or "nautilus"
config.editor      = config.editor      or "code"
config.launcher    = config.launcher    or "rofi -show drun -replace -i"
config.clipboard   = config.clipboard   or (home .. "/.local/bin/cliphist.sh")
config.wlogout     = config.wlogout     or (home .. "/.local/bin/wlogout-menu.sh")
config.hyprscripts = config.hyprscripts or (home .. "/.config/hypr/scripts")
config.aur_helper  = config.aur_helper  or "yay"
config.wallpaper_name = config.wallpaper_name or "SwissWallpaper"
config.wallpaper = config.wallpaper or (home .. "/wallpaper/" .. config.wallpaper_name .. ".JPG")
config.blurred_wallpaper = config.blurred_wallpaper or (home .. "/wallpaper/" .. config.wallpaper_name .. ".blurred.png")
config.rofi_font = config.rofi_font or "Fira Sans 11"
config.screenshot_folder  = config.screenshot_folder  or (home .. "/Pictures/Screenshots")
config.screenshot_editor  = config.screenshot_editor  or "pinta"

return config

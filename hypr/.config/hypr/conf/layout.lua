-- conf/layout.lua — dwindle layout, workspace binds, and gestures
-- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
-- preserve_split keeps splits on close; 3-finger horizontal swipe cycles workspaces

hl.config({
  dwindle = {
    preserve_split = true, -- keep splits when windows close
  },
  binds = {
    workspace_back_and_forth = true,  -- SUPER+<n> toggles back to previous ws
    allow_workspace_cycles   = true,  -- swipe cycles first ↔ last
    pass_mouse_when_bound    = false, -- don't pass click through when binding mouse
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" }) -- 3-finger swipe → workspace

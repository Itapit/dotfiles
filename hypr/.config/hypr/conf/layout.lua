-- conf/layout.lua — dwindle/master + binds + gestures (from conf/layouts/default.conf)

hl.config({
  dwindle = {
    preserve_split = true,
  },
  -- master is commented out in original — keep disabled
  -- master = { new_status = "master" },
  binds = {
    workspace_back_and_forth = true,
    allow_workspace_cycles   = true,
    pass_mouse_when_bound    = false,
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

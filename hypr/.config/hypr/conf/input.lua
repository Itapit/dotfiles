-- conf/input.lua — keyboard, mouse, and touchpad
-- https://wiki.hypr.land/Configuring/Variables/#input
-- kb_layout us,il + alt_shift_toggle switches between them

hl.config({
  input = {
    kb_layout          = "us,il",
    kb_options         = "grp:alt_shift_toggle",
    kb_variant         = "",
    kb_model           = "",
    numlock_by_default = true,
    follow_mouse       = 1,
    mouse_refocus      = false,
    touchpad = {
      natural_scroll = true,
      scroll_factor  = 1.0,
    },
    sensitivity = 0,
  },
})

#!/usr/bin/env bash
# wlogout-menu.sh — open wlogout with top/bottom margins scaled to the focused monitor.
# Margin = 27% of the logical height (height / scale). The old version stripped
# the dot from the scale ("1.00" -> 100), but hyprctl now prints "1", which
# made the margin 100x too large (29160px on a 1080p screen).

read -r res_h scale < <(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | "\(.height) \(.scale)"')
margin=$(awk -v h="${res_h:-1080}" -v s="${scale:-1}" 'BEGIN { printf "%d", h * 0.27 / s }')
wlogout -b 5 -T "$margin" -B "$margin"

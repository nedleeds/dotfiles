#!/usr/bin/env bash

raw="$(
  ~/.config/tmux/plugins/tmux-battery/scripts/battery_percentage.sh 2>/dev/null
)"

# 숫자만 추출 (예: "99%" -> "99", " 99 " -> "99")
PCT="$(printf '%s' "$raw" | tr -cd '0-9')"
[ -z "$PCT" ] && PCT=0

# power source (AC / Battery)
SOURCE="$(pmset -g ps 2>/dev/null | head -n 1)"

# Nerd Font icons (battery)
# charging: 󰂄
# full..empty: 󰁹 󰂀 󰁾 󰁺 󰂃
if echo "$SOURCE" | grep -q "AC Power"; then
  ICON="󰂄"
else
  if   [ "$PCT" -ge 90 ]; then ICON="󰁹"
  elif [ "$PCT" -ge 60 ]; then ICON="󰂀"
  elif [ "$PCT" -ge 30 ]; then ICON="󰁾"
  elif [ "$PCT" -ge 10 ]; then ICON="󰁺"
  else ICON="󰂃!"
  fi
fi

echo "$ICON ${PCT}%"

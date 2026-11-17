#!/bin/bash

get_icon() {
  case "$1" in
  brave-browser) echo "󰖟" ;;
  firefox) echo "󰈹" ;;
  kitty) echo "󰆍" ;;
  steam) echo "󰓓" ;;
  rpcs3) echo "󰊗" ;;
  dolphin) echo "" ;;
  code | code-oss) echo "󰨞" ;;
  discord) echo "󰙯" ;;
  spotify) echo "󰓇" ;;
  *) echo "󰘔" ;;
  esac
}

TMP=$(mktemp)

hyprctl clients -j | jq -r '
.[] |
select(.workspace.id > 0) |
"\(.class)|\(.title)|\(.address)"
' | while IFS='|' read -r class title address; do

  icon=$(get_icon "$class")

  # Limitar títulos muy largos
  short_title=$(echo "$title" | cut -c1-60)

  echo "$icon  $short_title|$address" >>"$TMP"

done

selection=$(
  cut -d'|' -f1 "$TMP" |
    rofi -dmenu \
      -i \
      -p "Ventanas" \
      -theme ~/.config/rofi/themes/noctalia.rasi
)

[ -z "$selection" ] && rm "$TMP" && exit

address=$(
  grep -F "$selection|" "$TMP" |
    head -n1 |
    cut -d'|' -f2
)

hyprctl dispatch "hl.dsp.focus({ window = 'address:$address' })"
hyprctl dispatch "hl.dsp.window.alter_zorder({ mode = 'top' })"
rm "$TMP"

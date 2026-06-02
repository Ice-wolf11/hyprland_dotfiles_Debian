#!/bin/bash

kitty \
  --class cheatsheet \
  --title "Hyprland Cheat Sheet" \
  bash -c '
    clear
    cat ~/.config/hypr/scripts/keybinds-help.txt
    echo
    echo "Presiona ENTER para cerrar..."
    read
  '

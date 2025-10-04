#!/bin/env bash

config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
gnome_schema="org.gnome.desktop.interface"

# Exit if config file is missing
if [ ! -f "$config" ]; then
  notify-send -u critical "Hyprland" "\nGTK config file missing at $(dirname "$config")."
  exit 1
fi

# Extract values from settings.ini
gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
cursor_size="$(grep 'gtk-cursor-theme-size' "$config" | sed 's/.*\s*=\s*//')"
font_name="$(grep 'gtk-font-name' "$config" | sed 's/gtk-font-name=\([^0-9]*\).*/\1/' | xargs)"
font_size="$(grep 'gtk-font-name' "$config" | sed 's/.* \([0-9]*\.[0-9]*\)$/\1/')"

# Notify if settings are missing
missing_settings=0

[ -z "$gtk_theme" ] && {
  notify-send -u critical "Hyprland" "GTK theme setting is missing in the config file."
  missing_settings=1
}
[ -z "$icon_theme" ] && {
  notify-send -u critical "Hyprland" "Icon theme setting is missing in the config file."
  missing_settings=1
}
[ -z "$cursor_theme" ] && {
  notify-send -u critical "Hyprland" "Cursor theme setting is missing in the config file."
  missing_settings=1
}
[ -z "$cursor_size" ] && {
  notify-send -u critical "Hyprland" "Cursor size setting is missing in the config file."
  missing_settings=1
}
[ -z "$font_name" ] && {
  notify-send -u critical "Hyprland" "Font name setting is missing in the config file."
  missing_settings=1
}
[ -z "$font_size" ] && {
  notify-send -u critical "Hyprland" "Font size setting is missing in the config file."
  missing_settings=1
}

[ "$missing_settings" -eq 1 ] && exit 1

get_setting() {
  case "$1" in
  gtk-theme)
    echo "$gtk_theme"
    ;;
  icon-theme)
    echo "$icon_theme"
    ;;
  cursor-theme)
    echo "$cursor_theme"
    ;;
  cursor-size)
    echo "$cursor_size"
    ;;
  font-name)
    echo "$font_name"
    ;;
  font-size)
    echo "$font_size"
    ;;
  *)
    notify-send -u critical "Hyprland" "Unknown setting '$1'. Skipping."
    ;;
  esac
}

set_setting() {
  font_with_size="$font_name $font_size"

  case "$1" in
  gtk-theme)
    echo "Setting GTK theme to '$gtk_theme'"
    gsettings set "$gnome_schema" gtk-theme "$gtk_theme" || notify-send -u critical "Hyprland" "\nCouldn't set gtk-theme"
    ;;
  icon-theme)
    echo "Setting icon theme to '$icon_theme'"
    gsettings set "$gnome_schema" icon-theme "$icon_theme" || notify-send -u critical "Hyprland" "\nCouldn't set icon-theme"
    ;;
  cursor-theme)
    echo "Setting cursor theme to '$cursor_theme'"
    gsettings set "$gnome_schema" cursor-theme "$cursor_theme" && hyprctl setcursor "$cursor_theme" "$cursor_size" || notify-send -u critical "Hyprland" "\nCouldn't set cursor-theme"
    ;;
  cursor-size)
    echo "Setting cursor size to '$cursor_size'"
    gsettings set "$gnome_schema" cursor-size "$cursor_size" || notify-send -u critical "Hyprland" "\nCouldn't set cursor-size"
    ;;
  font-name)
    echo "Setting font name to '$font_name'"
    gsettings set "$gnome_schema" font-name "$font_with_size" || notify-send -u critical "Hyprland" "\nCouldn't set font-name"
    ;;
  font-size)
    echo "Setting font size to '$font_size'"
    gsettings set "$gnome_schema" font-name "$font_with_size" || notify-send -u critical "Hyprland" "\nCouldn't set font-size"
    ;;
  *)
    notify-send -u critical "Hyprland" "Unknown setting '$1'."
    exit 1
    ;;
  esac
}

if [ "$#" -lt 2 ]; then
  notify-send -u critical "Hyprland" "GTK-config input error.\nUsage:\n\t hypr-gtkconf {get|set} <setting>"
  exit 1
fi

action="$1"
setting="$2"

case "$action" in
get)
  get_setting "$setting"
  ;;
set)
  set_setting "$setting"
  ;;
*)
  notify-send -u critical "Hyprand" "Unknown action '$action'.\nUse 'get' or 'set'."
  exit 1
  ;;
esac

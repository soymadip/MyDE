#!/bin/env bash

config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
gnome_schema="org.gnome.desktop.interface"

# Exit if config file is missing
if [ ! -f "$config" ]; then
  log.critical "GTK config file missing at $(dirname "$config")" -n
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
  log.critical "GTK theme setting is missing in the config file" -n
  missing_settings=1
}
[ -z "$icon_theme" ] && {
  log.critical "Icon theme setting is missing in the config file" -n
  missing_settings=1
}
[ -z "$cursor_theme" ] && {
  log.critical "Cursor theme setting is missing in the config file" -n
  missing_settings=1
}
[ -z "$cursor_size" ] && {
  log.critical "Cursor size setting is missing in the config file" -n
  missing_settings=1
}
[ -z "$font_name" ] && {
  log.critical "Font name setting is missing in the config file" -n
  missing_settings=1
}
[ -z "$font_size" ] && {
  log.critical "Font size setting is missing in the config file" -n
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
    log.error "Unknown setting '$1'. Skipping."
    ;;
  esac
}

set_setting() {
  font_with_size="$font_name $font_size"

  case "$1" in
  gtk-theme)
    log.info "Setting GTK theme to '$gtk_theme'"
    gsettings set "$gnome_schema" gtk-theme "$gtk_theme" || log.critical "Couldn't set gtk-theme" -n
    ;;
  icon-theme)
    log.info "Setting icon theme to '$icon_theme'"
    gsettings set "$gnome_schema" icon-theme "$icon_theme" || log.critical "Couldn't set icon-theme" -n
    ;;
  cursor-theme)
    log.info "Setting cursor theme to '$cursor_theme'"
    gsettings set "$gnome_schema" cursor-theme "$cursor_theme" && hyprctl setcursor "$cursor_theme" "$cursor_size" || log.critical "Couldn't set cursor-theme" -n
    ;;
  cursor-size)
    log.info "Setting cursor size to '$cursor_size'"
    gsettings set "$gnome_schema" cursor-size "$cursor_size" || log.critical "Couldn't set cursor-size" -n
    ;;
  font-name)
    log.info "Setting font name to '$font_name'"
    gsettings set "$gnome_schema" font-name "$font_with_size" || log.critical "Couldn't set font-name" -n
    ;;
  font-size)
    log.info "Setting font size to '$font_size'"
    gsettings set "$gnome_schema" font-name "$font_with_size" || log.critical "Couldn't set font-size" -n
    ;;
  *)
    log.critical "Unknown setting '$1'" -n
    exit 1
    ;;
  esac
}

if [ "$#" -lt 2 ]; then
  log.critical "GTK-config input error" -n
  log.usage "hypr-gtkconf {get|set} <setting>"
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
  log.critical "Unknown action '$action'. Use 'get' or 'set'" -n
  exit 1
  ;;
esac

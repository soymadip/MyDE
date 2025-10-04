#!/usr/bin/env bash
#   ____                             __  __
#  |  _ \ _____      _____ _ __     |  \/  | ___ _ __  _   _
#  | |_) / _ \ \ /\ / / _ \ '__|    | |\/| |/ _ \ '_ \| | | |
#  |  __/ (_) \ V  V /  __/ |       | |  | |  __/ | | | |_| |
#  |_|   \___/ \_/\_/ \___|_|       |_|  |_|\___|_| |_|\__,_|
#
#  Power Menu Script for Rofi - Shows power management options

# ======================== Config ===========================

theme_file="$HOME/.config/rofi/conf/power-menu.rasi"

# System Information
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Menu Options with Icons
shutdown=' ⏼  Shutdown'
reboot='   Reboot'
lock='   Lock'
screen_off=' 󰖦  Screen Off'
suspend=' ⏾  Suspend'
logout=' 󰗽  Logout'

# ==================== Helper Functions ======================

# Rofi command configuration
rofi_cmd() {
  rofi -dmenu \
    -p "$host" \
    -mesg "Uptime: $uptime" \
    -theme "${theme_file}"
}

# Display rofi menu and get user choice
run_rofi() {
  choice=$(echo -e "$suspend\n$shutdown\n$lock\n$screen_off\n$reboot\n$logout" | rofi_cmd)

  [[ -z "$choice" ]] && exit 0

  echo "$choice"
}

lock_cmd() {
  sleep 1
  loginctl lock-session
}

# Execute the selected power management command
run_cmd() {
  case $1 in
  '--shutdown')
    systemctl poweroff
    ;;
  '--reboot')
    systemctl reboot
    ;;
  '--suspend')
    mpc -q pause
    lock_cmd
    systemctl suspend
    ;;
  '--screen-off')
    lock_cmd
    case "$DESKTOP_SESSION" in
    hyprland*)
      sleep 0.5 && hyprctl dispatch dpms toggle
      ;;
    *)
      notify-send "Power Menu" "Screen off is not available in $DESKTOP_SESSION"
      exit 1
      ;;
    esac
    ;;
  '--logout')
    case "$DESKTOP_SESSION" in
    'plasma')
      qdbus6 org.kde.ksmserver /KSMServer logout 0 0 0
      ;;
    'gnome')
      gnome-session-quit --logout --no-prompt
      ;;
    *-uwsm)
      uwsm stop
      ;;
    'hyprland')
      hyprctl dispatch exit
      ;;
    esac
    ;;
  '--lock')
    lock_cmd
    ;;
  esac
}

#========================== Main Logic =========================

# Get user choice and exit if none selected
chosen="$(run_rofi)"

[[ -z "$chosen" ]] && exit 1

# Execute the corresponding action
case $chosen in
"$shutdown")
  run_cmd --shutdown
  ;;
"$reboot")
  run_cmd --reboot
  ;;
"$lock")
  run_cmd --lock
  ;;
"$suspend")
  run_cmd --suspend
  ;;
"$logout")
  run_cmd --logout
  ;;
"$screen_off")
  run_cmd --screen-off
  ;;
*)
  exit 1
  ;;
esac

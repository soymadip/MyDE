#!/bin/env bash

#echo pass1
if [[ -z "$1" ]]; then
  hypr-notify -c "Hypr-restart" "<b>Error</b>: No process name provided!"
  exit 1
fi

#echo pass2

restarted=0

if ! pgrep -x "$1"; then
  #echo pass3
  [[ "$1" == "ags" ]] || hypr-notify -c "Hypr-restart" "<b>Process not running</b>: $1\nStarting..."
  #echo pass3.5
  if ! eval "$1 &"; then
    echo pass4
    hypr-notify -c "Hypr-restart" "<b>Failed to start</b>: $1"
    exit 1
  fi
  #echo pass5
else
  if killall "$1" 2>/dev/null; then
    if ! eval "$1 &"; then
      hypr-notify -c "Hypr-restart" "<b>Failed to restart</b>: $1"
      exit 1
    fi
    restarted=1
  else
    hypr-notify -c "Hypr-restart" "<b>Failed to terminate</b>: $1"
    exit 1
  fi
fi

case "$1" in
"ags")
  sleep 5
  ;;
*)
  sleep 3
  ;;
esac

if [[ "$restarted" -eq 1 ]]; then
  hypr-notify -n "Hypr-restart" "<b>Restarted</b>: $1"
else
  hypr-notify -n "Hypr-restart" "<b>Started</b>: $1"
fi

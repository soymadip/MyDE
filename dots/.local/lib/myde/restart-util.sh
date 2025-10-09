#!/bin/env bash

#echo pass1
if [[ -z "$1" ]]; then
  log.critical "No process name provided" -n
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
    log.critical "Failed to start: $1" -n
    exit 1
  fi
  #echo pass5
else
  if killall "$1" 2>/dev/null; then
    if ! eval "$1 &"; then
      log.critical "Failed to restart: $1" -n
      exit 1
    fi
    restarted=1
  else
    log.critical "Failed to terminate: $1" -n
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
  log.success "Restarted: $1" -n
else
  log.success "Started: $1" -n
fi

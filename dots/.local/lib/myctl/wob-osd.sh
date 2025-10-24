#!/usr/bin/env bash

# Show a wob-style on-screen display (OSD) bar for levels

# =================== Configuration ====================#

 WOB_MAX_LEVEL="${WOB_MAX_LEVEL:-200}"
 WOB_INFO_FILE="${WOB_INFO_FILE:-$LOG_DIR/wob-pipe.info}"

# =================== Functions ====================#

# Check If wob daemon is running; if not, start it
start-wob-daemon() {
    local wob_pipe="/tmp/${HYPRLAND_INSTANCE_SIGNATURE:-myde_$(date +%s)}.wob"

    log.debug "Wob pipe: '$wob_pipe'"

    echo "$wob_pipe" > "$WOB_INFO_FILE"

    if [ -e "$wob_pipe" ] && [ ! -p "$wob_pipe" ]; then
        log.error "$wob_pipe exists but is not a FIFO pipe!"
        rm "$wob_pipe" && mkfifo "$wob_pipe"
    elif [ ! -p "$wob_pipe" ]; then
        log.info "Creating FIFO pipe at $wob_pipe"
        mkfifo "$wob_pipe"
    fi

    # Check if the daemon is already running
    pgrep -f "tail -f $wob_pipe" >/dev/null && {
        log.info "Wob daemon is already running."
        return 0
    }

    # Launch the daemon
    log.debug "Starting wob daemon... "

    tail -f "$wob_pipe" | wob & disown || {
        log.error "Failed to start wob daemon."
        return 1
    }
}

#---------------------------------------------------------------------------

# if executed directly,
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "this is part of myctl controller program lib."
  echo "use 'myctl help' for more info."
fi

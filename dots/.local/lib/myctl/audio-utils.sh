#!/bin/env bash

#========================= Configuration =========================#

MAX_VOLUME=${MAX_VOLUME:-153}
MAX_MIC=${MAX_MIC:-153}

#========================= Functions =========================#

get-volume() {
    local mic=false
    local pactl_cmd="get-sink-volume"
    local pactl_device="@DEFAULT_SINK@"

    case "$1" in
        -m)
            mic=true
            pactl_cmd="get-source-volume"
            pactl_device="@DEFAULT_SOURCE@"
            ;;
    esac

    pactl "$pactl_cmd" "$pactl_device" | grep -oP '[0-9]+(?=%)' | head -n 1
}


# Usage: set-volume [-m] [+\-]<level> | <exact_level>
set-volume() {
    local change symbol direction req_level current_level new_level
    local mic=false device pactl_cmd

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -m)
                mic=true
                ;;
            *)
                case "$1" in
                    ''|*[!0-9]*)
                        symbol="${1:0:1}"
                        case "$symbol" in
                            +|-)
                                direction="$symbol"
                                change="${1:1}"
                                ;;
                            *)
                                log.fatal "Invalid Volume direction: '$symbol'"
                                return 1
                                ;;
                        esac
                        ;;
                    *)
                        req_level="$1"
                        ;;
                esac
                ;;
        esac
        shift
    done

    log.debug "0. Requested Level: $req_level, Change: $change, direction: $direction"

    # Determine Max Limit and Target Device
    if "$mic"; then
        max_limit=$MAX_MIC
        device="@DEFAULT_SOURCE@"
        pactl_cmd="set-source-volume"
        current_level=$(get-volume -m)
    else
        max_limit=$MAX_VOLUME
        device="@DEFAULT_SINK@"
        pactl_cmd="set-sink-volume"
        current_level=$(get-volume)
    fi

    log.debug "1. Current Level: $current_level, Change: $change,  req_level: $req_level, Current Level: $current_level"

    # Determine requested level
    if [ "$direction" == "+" ]; then
        [ -z "$req_level" ] && req_level=$((current_level + change))
    else
        [ -z "$req_level" ] && req_level=$((current_level - change))
    fi

    log.debug "2. Current Level: $current_level, Change: $change,  req_level: $req_level, Current Level: $current_level"

    # Clamp requested level to valid range [0, max_limit]
    if (( req_level > max_limit )); then
        log.warn "Max Volume limit: $max_limit"
        req_level=$max_limit
    elif (( req_level < 0 )); then
        req_level=0
    fi

    log.debug "Final: Current Level: $current_level, Change: $change,  req_level: $req_level, Current Level: $current_level"

    pactl "$pactl_cmd" "$device" "${req_level}%"

}


#---------------------------------------------------------------------------

# if executed directly,
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "this is part of myctl controller program lib."
    echo "use 'myctl help' for more info."
fi

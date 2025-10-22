#!/bin/env bash

#========================= Configuration =========================#

MAX_VOLUME=${MAX_VOLUME:-153}
MAX_MIC=${MAX_MIC:-$MAX_VOLUME}

#========================= Functions =========================#

get-volume() {
    local mic=false volume
    local wpctl_device="@DEFAULT_AUDIO_SINK@"

    case "$1" in
        -m|--mic)
            mic=true
            wpctl_device="@DEFAULT_AUDIO_SOURCE@"
            ;;
    esac

    # Use wpctl to get the volume and convert the reported fractional value to percent
    volume="$(
        wpctl get-volume "$wpctl_device" \
            | awk '{ printf("%d", $2 * 100) }'
    )"

    [ -z "$volume" ] && log.error "Failed to get volume level." && return 1

    echo "$volume"
}


# Usage: set-volume [-m] [+\-]<level> | <exact_level>
set-volume() {
    local change symbol direction req_level current_level new_level
    local mic=false device

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -m|--mic)
                mic=true
                ;;
            *)
                if [[ "$1" =~ ^[+-][0-9]+$ ]]; then
                    direction="${1:0:1}"
                    change="${1:1}"
                elif [[ "$1" =~ ^[0-9]+$ ]]; then
                    req_level="$1"
                else
                    log.error "Invalid volume argument: '$1'. Expected +<level>, -<level>, or <level>."
                    return 1
                fi
                ;;
        esac
        shift
    done

    log.debug "0. Requested Level: $req_level, Change: $change, direction: $direction"

    # Determine Max Limit and Target Device
    if "$mic"; then
        max_limit=$MAX_MIC
        device="@DEFAULT_AUDIO_SOURCE@"
        current_level=$(get-volume -m)
    else
        max_limit=$MAX_VOLUME
        device="@DEFAULT_AUDIO_SINK@"
        current_level=$(get-volume)
    fi

    log.debug "1. Current Level: $current_level, Change: $change,  req_level: $req_level, Current Level: $current_level"

    # Validate current level
    ! [[ "$current_level" =~ ^[0-9]+$ ]] && {
        log.error "Unable to parse current volume level: '$current_level'."
        return 2
    }

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

    wpctl set-volume "$device" "${req_level}%" || {
        log.error "Failed to Set volume via wpctl"
        return 3
    }

}


#---------------------------------------------------------------------------

# if executed directly,
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "this is part of myctl controller program lib."
    echo "use 'myctl help' for more info."
fi

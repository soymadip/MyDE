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
    local change mic=false current_volume requested_value max_limit
    local device pactl_cmd

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -m)
                mic=true
                ;;
            *)
                change="$1"
                ;;
        esac
        shift
    done

    # Check for missing argument
    if [ -z "$change" ]; then
        log.error "Missing volume level."
        return 1
    fi

    # 2. Determine Max Limit and Target Device
    if "$mic"; then
        max_limit=$MAX_MIC
        device="@DEFAULT_SOURCE@"
        pactl_cmd="set-source-volume"
    else
        max_limit=$MAX_VOLUME
        device="@DEFAULT_SINK@"
        pactl_cmd="set-sink-volume"
    fi

    # 3. Handle Exact Value Input ("75")
    if [[ "$change" =~ ^[0-9]+$ ]]; then
        requested_value=$change

        # Check if the requested value exceeds the max limit
        if (( requested_value > max_limit )); then
            log.warn "Cannot set volume to ${requested_value}%. Max limit is ${max_limit}%." -n
            change="${max_limit}%"
        else
            change="${requested_value}%"
        fi

        pactl "$pactl_cmd" "$device" "$change"
        return 0
    fi

    # 4. Handle Relative Change Input ("+5%" or "-10")
    if [[ "$change" =~ ^[+\-][0-9]+ ]]; then
        local direction=${change:0:1}
        local step=${change:1}
        local potential_volume difference

        # Get current volume only if increasing volume
        if [[ "$direction" == "+" ]]; then

            current_volume=$(get-volume ${mic:+-m})

            # Calculate the wanted volume
            potential_volume=$(( current_volume + step ))

            # Check the limit
            if (( potential_volume > max_limit )); then

                # get the diff to max limit
                difference=$(( max_limit - current_volume ))

                if (( difference > 0 )); then
                    change="+${difference}%"
                    log.warn "Adjusted increase to ${difference}% to meet ${max_limit}% limit." >&2
                else
                    log.warn "Warning: Volume already at or above ${max_limit}%. Skipping increase." >&2
                    return 0
                fi
            else
                # If within limits, add %
                change="${direction}${step}%"
            fi
        fi

        pactl "$pactl_cmd" "$device" "$change"

        return 0
    fi

    # Fallback for unrecognized input format
    log.error "Unrecognized volume level format: '$change'. Expected: [+\-]<level> or <exact_level>" >&2
    return 1
}


#---------------------------------------------------------------------------

# if executed directly,
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "this is part of myctl controller program lib."
    echo "use 'myctl help' for more info."
fi

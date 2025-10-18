#!/usr/bin/env bash

# Enable alias expansion in non-interactive mode
shopt -s expand_aliases

# Exit if logger cannot be loaded - it's a critical dependency
if ! declare -f log.error >/dev/null 2>&1; then

    LOGGER_PATH="${LIB_DIR:-$HOME/.local/lib/myctl}/logger.sh"

    if [[ -f "$LOGGER_PATH" ]]; then
        source "$LOGGER_PATH"
    else
        echo "FATAL: Cannot load logger from '$LOGGER_PATH'" >&2
        exit 1
    fi
fi

# shellcheck disable=SC2142
alias require_arg='shift && [ -n "$1" ]'

#---------------

self() {
    "$THIS_PATH" "$@"
}

#---------------

import_lib() {
    local lib_file="$1"
    local target_paths=()

    [ -n "$lib_file" ] || {
        log.error "No library file specified to import."
        exit 1
    }

    if [[ "$lib_file" == */* || "$lib_file" == /* ]]; then
        target_paths+=("$lib_file")
        [[ "$lib_file" != *.sh ]] && target_paths+=("${lib_file}.sh")
    else
        target_paths+=("${LIB_DIR}/${lib_file}")
        [[ "$lib_file" != *.sh ]] && target_paths+=("${LIB_DIR}/${lib_file}.sh")
    fi

    for p in "${target_paths[@]}"; do
        if [ -f "$p" ]; then
            source "$p"
            return 0
        fi
    done

    log.error "Library file '${LIB_DIR}/${lib_file}' not found."
    exit 1
}

#---------------

run_script() {
    local script_path="$1"

    shift  # Shift to skip the 1st argument (script path)

    if [ -x "$script_path" ]; then
        "$script_path" "$@"
    else
        log.error "Script '$script_path' not found or not executable."
        exit 1
    fi
}

#---------------

invld_cmd() {
    local unknown_cmd="$1"
    echo ""

    if [ "$unknown_cmd" == "" ]; then
        echo "No command provided."
    else
        echo "Unknown command: '$unknown_cmd'."
    fi

}

#---------------

help_menu() {
    local command="${cmd_map[cmd]}"

    ! [ ${cmd_map[usage]+_} ] && {
        if [ "$command" == "myctl" ]; then
            cmd_map[usage]="${cmd_map[cmd]} <cmd> [subcommand]"
        else
            cmd_map[usage]="myctl ${cmd_map[cmd]} [subcommand]"
        fi
    }

    echo ""
    if [ "$command" == "myctl" ]; then
        echo "MyDE Controller - Control Various Functions of MyDE"
        echo ""
        echo "Usage: ${cmd_map[usage]}"
    else
        echo "MyDE Controller - '$command' command"
        echo ""
        echo "Usage: ${cmd_map[usage]}"
    fi
    echo ""

    echo "Commands: "
    _print_help_cmds cmd_map
}

#---------------

# _print_help_cmds <dict_name>
_print_help_cmds() {
    local -n arr="$1"
    local -a skip_keys=(cmd usage)
    local -a filtered_keys=()
    local max_len=0

    arr[help]="Show help menu"
    skip_keys+=("help")

    # First loop: Find maximum key length and filter out skipped keys
    for key in "${!arr[@]}"; do
        local should_skip=0
        for s_key in "${skip_keys[@]}"; do
            if [[ "$key" == "$s_key" ]]; then
                should_skip=1
                break
            fi
        done
        if [[ "$should_skip" -eq 0 ]]; then
            filtered_keys+=("$key")
            (( ${#key} > max_len )) && max_len=${#key}
        fi
    done

    # Print filtered commands
    for key in "${filtered_keys[@]}"; do
        printf "   %-$((max_len + 4))s %s\n" "$key" "${arr[$key]}"
    done

    # print help at last
    printf "   %-$((max_len + 4))s %s\n" "help" "${arr[help]}"

}

#---------------------------------------------------------------------------

# if executed directly,
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "this is part of myctl controller program lib."
    echo "use 'myctl help' for more info."
fi

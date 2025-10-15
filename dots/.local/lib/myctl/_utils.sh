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
    local command="${sub_cmds[cmd]}"
    echo ""

    if [ "$command" == "myctl" ]; then
        echo "MyDE Controller - Control Various Functions of MyDE"
        echo ""
        echo "Usage: myctl <command> [subcommand]"
    else
        echo "MyDE Controller - '$command' command"
        echo ""
        echo "Usage: myctl $command [subcommand]"
    fi
    echo ""

    echo "Commands: "
    _print_help_cmds sub_cmds cmd
}

#---------------

# _print_help_cmds <dict_name> [skip_key]
_print_help_cmds() {
    local -n arr="$1"
    local skip_key="$2"
    local max_len=0
    local help_desc="Show this help Menu"

    # Auto-add help if not present and not being skipped
    if [[ -z "${arr[help]}" && "$skip_key" != "help" ]]; then
        arr[help]="$help_desc"
    fi

    # Find maximum key length
    for key in "${!arr[@]}"; do
        [[ -n "$skip_key" && "$key" == "$skip_key" ]] && continue
        (( ${#key} > max_len )) && max_len=${#key}
    done

    # Print remaining commands first
    for key in "${!arr[@]}"; do
        [[ -n "$skip_key" && "$key" == "$skip_key" ]] && continue
        [[ "$key" == "help" ]] && continue
        printf "   %-$((max_len + 4))s %s\n" "$key" "${arr[$key]}"
    done

    # Print help last
    if [[ -n "${arr[help]}" && "$skip_key" != "help" ]]; then
        printf "   %-$((max_len + 4))s %s\n" "help" "${arr[help]}"
    fi
}



#---------------------------------------------------------------------------

# if executed directly,
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "this is part of myctl controller program lib."
    echo "use 'myctl help' for more info."
fi

#!/usr/bin/env bash

# Enable alias expansion in non-interactive mode
shopt -s expand_aliases

# Exit if logger cannot be loaded - it's a critical dependency
if ! declare -f log.error >/dev/null 2>&1; then
    LOGGER_PATH="${LIB_DIR:-$HOME/.local/lib/myde}/logger.sh"
    if [[ -f "$LOGGER_PATH" ]]; then
        source "$LOGGER_PATH"
    else
        echo "FATAL: Cannot load logger from '$LOGGER_PATH'" >&2
        exit 1
    fi
fi

alias require_arg='shift && [ -z "$1" ]'

#---------------

self() {
    "$THIS_PATH" "$@"
}

#---------------

import_lib() {
    local lib_file="$1"

    [ -n "$lib_file" ] || {
        log.error "No library file specified to import."
        exit 1
    }

    if [ -f "${LIB_DIR}/${lib_file}" ]; then
        source "${LIB_DIR}/${lib_file}"
    else
        log.error "Library file '${LIB_DIR}/${lib_file}' not found."
        exit 1
    fi
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
    echo "Unknown command: '$unknown_cmd'."
}

#---------------

help_menu() {
    local command="${sub_cmds[cmd]}"
    echo ""

    if [ "$command" == "myde" ]; then
        echo "MyDE Controller - Control Various Functions of MyDE"
        echo ""
        echo "Usage: myde <command> [subcommand]"
    else
        echo "MyDE Controller - '$command' command"
        echo ""
        echo "Usage: myde $command [subcommand]"
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
    echo "this is part of myde controller program lib."
    echo "use 'myde help' for more info."
fi

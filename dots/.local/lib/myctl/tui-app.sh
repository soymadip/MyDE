#!/usr/bin/env bash
#
#
#==> open-tui [flags] <cmd> [args...]
#
# DESCRIPTION:
#   Open any TUI application in Default/specified terminal emulator.
#   Supports passing Class name & Terminal name.
#
# FLAGS:
#   -e, --exec     Command to run
#   -t, --term     Terminal emulator
#   -c, --class    Application class
#   -h, --help     Show this help message
#
# Usage examples:
#   open-tui htop
#   open-tui "bash -c 'tmux new -A -s dev"
#   open-tui -c MyClass -t alacritty -- bash -c 'tmux new -A -s dev'
#   open-tui -c MyClass -t kitty -e htop ls
#

#-------------- Functions ------------------#

# Entrypoint expected by myctl: `open-tui`
open-tui() {
    local exec_cmd=""
    local term_class=""
    local terminal_bin=""
    local terminal_cmd="${TERMINAL:-wezterm start}"

   [[ $# -eq 0 ]] && {
       log.error "No arguments provided."
       return 1
   }

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -t|--term)
                shift_arg || { log.error "No terminal name specified after '-t|--term'"; help_menu; return 1; }
                terminal_cmd="$1"
                ;;
            -c|--class)
                shift_arg || { log.error "No class name specified after '-c|--class'"; help_menu; return 1; }
                term_class="$1"
                ;;
            --|'-e'|--exec)
                shift_arg || { log.error "No command specified after '-e|--exec'"; return 1; }
                exec_cmd="$*"
                break
                ;;
            -h|--help|help)
                _help_menu
                return 0
                ;;
            -*)
                log.error "Unknown option: $1"
                help_menu
                return 1
                ;;
            *)
                exec_cmd="$*"
                break
                ;;
        esac
        shift
    done

    # Extract the binary name
    read -r -a terminal_arr <<< "$terminal_cmd"
    terminal_bin="${terminal_arr[0]}"

    log.debug "Using terminal: $terminal_bin"

    # Validate required arguments
    if [[ -z "$exec_cmd" ]]; then
        log.error "No command specified to execute. Use -e/--exec or pass the command after '--'."
        help_menu
        return 1
    fi

    if ! command -v "$terminal_bin" >/dev/null 2>&1; then
        log.error "Terminal '$terminal_bin' not found in PATH."
        help_menu
        return 1
    fi

    exec_cmd="${terminal_cmd} --class $term_class -e $exec_cmd"
    log.debug "Final command: $exec_cmd"

    $exec_cmd >/dev/null 2>&1 & disown 2>/dev/null || true

    return 0
}


#------------ Execution Message --------------#
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This is part of MyDE controller program lib."
    echo "Use 'myctl help' for more info."
fi

#!/usr/bin/env bash

# Enable alias expansion in non-interactive mode
shopt -s expand_aliases

# Exit if logger cannot be loaded - it's a critical dependency
if ! declare -f log.error >/dev/null 2>&1; then

    LOGGER_PATH="${LIB_DIR:-$HOME/.local/lib/myctl}/logger.sh"

    if [[ -f "$LOGGER_PATH" ]]; then
        source "$LOGGER_PATH" && {

            # Export all functions
            while IFS= read -r func_name; do
                [[ -n "$func_name" ]] && export -f "$func_name"
            done < <(awk '/^[a-zA-Z_][a-zA-Z0-9_-]*\s*\(\)/ {sub(/\s*\(\).*/, ""); print}' "$LOGGER_PATH")
        }
    else
        echo "FATAL: Cannot load logger from '$LOGGER_PATH'" >&2
        exit 1
    fi
fi

# shellcheck disable=SC2142
alias shift_arg='shift && [ -n "$1" ]'

#---------------

self() {
    "$THIS_PATH" "$@"
}

#---------------

declare -A _IMPORTED_LIBS

import_lib() {
    local mode="import"
    local lib_files=()
    local target_paths=()
    local lib_file

    # Parse flags
    while [ $# -gt 0 ]; do
        case "$1" in
            --check|-c)
                mode="check"
                shift
                [ -z "$1" ] && {
                    log.error "No library file specified for --check."
                    exit 1
                }
                lib_files=("$1")
                shift
                ;;
            --list|-l)
                mode="list"
                shift
                ;;
            --help|-h)
                cat << 'EOF'
                    import_lib - Import library files with tracking

                Usage:
                    import_lib [library1] [library2]        Import one or more libraries
                    import_lib --check|-c <library>         Check if library is imported
                    import_lib --list|-l                    List all imported libraries
                    import_lib --help|-h                    Show this help
EOF
                return 0
                ;;
            -*)
                log.error "Unknown flag: $1"
                exit 1
                ;;
            *)
                lib_files+=("$1")
                shift
                ;;
        esac
    done

    # Handle different modes
    case "$mode" in
        list)
            [ ${#_IMPORTED_LIBS[@]} -eq 0 ] && {
                log.error "No libraries imported yet."
                return 0
            }
            echo "Imported libraries:"
            for lib_path in "${!_IMPORTED_LIBS[@]}"; do

                local display_name
                local resolved_lib_dir=$(realpath "$LIB_DIR" 2>/dev/null || echo "$LIB_DIR")

                # Check if it's in the standard lib directory (using resolved paths)
                if [[ "$lib_path" == "$resolved_lib_dir"/* ]]; then
                    # Extract just the filename, remove .sh extension if present
                    display_name=$(basename "$lib_path" .sh)
                elif [[ "$lib_path" == *"$LIB_DIR"* ]]; then
                    # Handle relative lib paths
                    display_name=$(basename "$lib_path" .sh)
                else
                    # For non-standard paths, show relative path if possible
                    if [[ "$lib_path" == "$PWD"/* ]]; then
                        # Show relative to current directory
                        display_name="${lib_path#$PWD/}"
                    else
                        # Show the full path for absolute paths outside current dir
                        display_name="$lib_path"
                    fi
                fi

                echo "  $display_name"
            done
            return 0
            ;;
        check)
            [ -z "${lib_files[0]}" ] && {
                log.error "No library file specified to check."
                return 1
            }

            lib_file="${lib_files[0]}"

            if [[ "$lib_file" == */* || "$lib_file" == /* ]]; then
                target_paths+=("$lib_file")
                [[ "$lib_file" != *.sh ]] && target_paths+=("${lib_file}.sh")
            else
                target_paths+=("${LIB_DIR}/${lib_file}")
                [[ "$lib_file" != *.sh ]] && target_paths+=("${LIB_DIR}/${lib_file}.sh")
            fi

            for p in "${target_paths[@]}"; do
                if [ -f "$p" ]; then
                    local resolved_path=$(realpath "$p")
                    [[ -n "${_IMPORTED_LIBS[$resolved_path]:-}" ]] && return 0
                    break
                fi
            done
            return 1
            ;;

        import)
            [ ${#lib_files[@]} -eq 0 ] && {
                log.error "No library file(s) specified to import."
                exit 1
            }

            for lib_file in "${lib_files[@]}"; do
                [ -z "$lib_file" ] && continue

                target_paths=()

                if [[ "$lib_file" == */* || "$lib_file" == /* ]]; then
                    target_paths+=("$lib_file")
                    [[ "$lib_file" != *.sh ]] && target_paths+=("${lib_file}.sh")
                else
                    target_paths+=("${LIB_DIR}/${lib_file}")
                    [[ "$lib_file" != *.sh ]] && target_paths+=("${LIB_DIR}/${lib_file}.sh")
                fi

                local found=false
                local resolved_path=""

                for p in "${target_paths[@]}"; do
                    [ -f "$p" ] && {
                        resolved_path=$(realpath "$p")

                        # Check if already imported
                        if [[ -n "${_IMPORTED_LIBS[$resolved_path]:-}" ]]; then
                            found=true
                            break
                        fi

                        source "$p" && {

                            # Export all functions defined in library file
                            while IFS= read -r func_name; do
                                if [[ -n "$func_name" ]]; then

                                    export -f "$func_name"
                                fi
                            done < <(awk '/^[a-zA-Z_][a-zA-Z0-9_-]*\s*\(\)/ {sub(/\s*\(\).*/, ""); print}' "$p")

                            _IMPORTED_LIBS["$resolved_path"]=1
                            found=true
                        }
                        break
                    }
                done

                [ "$found" = false ] && {
                    log.error "Library file '${lib_file}' not found."
                    exit 1
                }
            done
            ;;
    esac
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
        log.error "No command provided."
    else
        log.error "Unknown command: '$unknown_cmd'."
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
        echo "MyCTL - Control Various Functions of MyDE"
        echo ""
        echo "Usage: ${cmd_map[usage]}"
    else
        echo "MyCTL - '$command' command"
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

#-----------------

# Usage: read-conf <key_name> <hypr_file>
# Limitation: Doesn't expand hyprlang vars. only shell vars/cmds.
# TODO:
#       default file support
#       default value support
read-conf() {
    local key_name raw_value final_value \
          hypr_file="${2:-$MYDE_CONF}"

    [[ -z "$1" ]] && {
        log.error "Error: No key name provided."
        return 1
    }

    key_name=$1

    [[ ! -f "$hypr_file" ]] && {
        log.error "Error: Config file not found at $hypr_file"
        return 1
    }

    # Find the key & Extract Value
    raw_value=$(awk -F'=' -v key="$key_name" '
      $0 ~ key && /^\s*\$/ {
        sub(/#.*/, "", $2) # Remove comments from the value
        print $2           # Print the value
      }
    ' "$hypr_file" | xargs)

    [[ -z "$raw_value" ]] && {
        log.error "Error: Key not found: $key_name"
        return 1
    }

    # Expand Value
    final_value=$(eval echo "$raw_value")

    # Return Result
    echo "$final_value"
}


#--------------- If executed directly ----------------------

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This is part of myctl lib."
    echo "Use 'myctl help' for more info."
fi

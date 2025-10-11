#!/usr/bin/env bash
#
#
#==> get-desktop-file [flags] <cmd_name>
#
# DESCRIPTION:
#   Finds desktop files by command name.
#   Searches user, system, and flatpak locations.
#
# FLAGS:
#   -n, --name    Output just filename instead of full path (default: full path)

get-desktop-file() {
    # Local variables
    local cmd_name search_dirs pattern dir find_result desktop_file_name
    local output_path=true

    # Command replacement mapping
    #   Eg. zen.desktop has: Exec=zen-bin %U
    declare -A cmd_replacements=(
        ["zen-browser"]="zen-bin"
        ["zeditor"]="zed-editor"
    )

    # Search directories in priority order
    search_dirs=(
        "$HOME/.local/share/applications"
        "/usr/share/applications"
        "/var/lib/flatpak/exports/share/applications"
    )

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--name)
                output_path=false
                shift
                ;;
            -cn|--cmd-name)
            ;;
            *)
                if [[ -z "$cmd_name" ]]; then
                    cmd_name="$1"
                    shift
                else
                    log.error "Unknown argument '$1'"
                    log.usage "get-desktop-file [-n|--name] <cmd_name>"
                    return 1
                fi
                ;;
        esac
    done


    # Validate input
    if [[ -z "$cmd_name" ]]; then
        log.usage "get-desktop-file [-n|--name] <cmd_name>"
        return 1
    fi

    # Extract basename if full path is provided
    if [[ "$cmd_name" == */* ]]; then
        cmd_name=$(basename "$cmd_name")
    fi

    # Check if command is valid
    if ! command -v "$cmd_name" >/dev/null 2>&1; then
        log.error "Command '$cmd_name' not found in PATH."
        return 1
    fi

    # Handle command replacements
    local original_cmd="$cmd_name"
    local replacement_used=false
    if [[ -n "${cmd_replacements[$cmd_name]}" ]]; then
        cmd_name="${cmd_replacements[$cmd_name]}"
        replacement_used=true
    fi

    # Construct regex pattern for Exec= line
    # Match command name anywhere in path (as final component)
    pattern="Exec=.*[/[:space:]]${cmd_name}([[:space:]%]|$)|Exec=${cmd_name}([[:space:]%]|$)"

    # Search directories in priority order
    for dir in "${search_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            # Find desktop file containing the command
            find_result=$(find "$dir" -name "*.desktop" -exec grep -l -E -i "$pattern" {} \; 2>/dev/null)

            # If found, output result and exit
            if [[ -n "$find_result" ]]; then
                if [[ "$output_path" == true ]]; then
                    echo "$find_result"
                else
                    desktop_file_name=$(basename "$find_result")
                    echo "$desktop_file_name"
                fi
                return 0
            fi
        fi
    done

    # No desktop file found - show appropriate error message
    if [[ "$replacement_used" == true ]]; then
        log.error "No desktop file found for command '$original_cmd' (searched for '$cmd_name')."
    else
        log.error "No desktop file found for command '$original_cmd'."
    fi
    return 1
}


# If executed directly Show Info
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This is part of MyDE controller program lib."
    echo "Use 'myctl help' for more info."
fi

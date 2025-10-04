# Zsh function to find the desktop file name from a command name.
# It prioritizes user-specific, then system-wide, then Flatpak desktop files.
# 
# Usage: get-desktop-file <command_name>
#
# LIMITATION :- Exac command has to be same as command

get-desktop-file() {
    # Local variables for the function
    local command_name
    local search_dirs
    local command_path
    local pattern
    local dir
    local find_result
    local desktop_file_name

    if [[ -z "$1" ]]; then
        echo "Usage: get-desktop-file <command_name>" >&2
        return 1
    fi

    command_name="$1"

    # Define search directories in the correct order of precedence
    search_dirs=(
        "$HOME/.local/share/applications"
        "/usr/share/applications"
        "/var/lib/flatpak/exports/share/applications"
    )

    # Construct a regex pattern for the Exec= line
    command_path=$(which "$command_name" 2>/dev/null)
    if [[ -n "$command_path" ]]; then
        pattern="Exec=(${command_name}|${command_path})[\s%]*"
    else
        pattern="Exec=${command_name}[\s%]*"
    fi

    # Loop through the directories in priority order
    for dir in "${search_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            # Use find to locate the desktop file within the current directory
            find_result=$(find "$dir" -name "*.desktop" -exec grep -l -E -i "$pattern" {} \; 2>/dev/null)

            # If a desktop file is found, we have our match
            if [[ -n "$find_result" ]]; then
                # Use basename to extract the filename from the full path
                desktop_file_name=$(basename "$find_result")
                echo "$desktop_file_name"
                return 0 # Return success code and exit the function
            fi
        fi
    done

    # If the loop completes without finding a file, nothing was found
    echo "Error: No desktop file found for command '$command_name'." >&2
    return 1
}


#==> myctl get hconf <key> [filename]
#    defaults to: ~/.config/myde/myde.conf

# Usage: get-hconf <key_name> <hypr_file>
# Limitation: Doesn't expand hyprlang vars. only shell vars/cmds.
# TODO:
#       default file support
#       default value support
read-hconf() {
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

#!/usr/bin/env bash

# ==================== Configuration ====================

# Default log level (0=debug, 1=info, 2=warn, 3=error, 4=critical)
LOG_LEVEL="${LOG_LEVEL:-1}"

# Enable/disable colored output
LOG_COLOR="${LOG_COLOR:-true}"

# Enable/disable timestamps
LOG_TIMESTAMP="${LOG_TIMESTAMP:-false}"

# Log file path (empty = disabled)
LOG_FILE="${LOG_FILE:-}"

# Notification settings
LOG_NOTIFY="${LOG_NOTIFY:-false}"

NOTIFY_BIN="$(command -v notify-send)"

# ==================== Color Codes ====================

if [[ "$LOG_COLOR" == "true" ]]; then
    COLOR_RESET='\033[0m'
    COLOR_DEBUG='\033[0;36m'    # Cyan
    COLOR_INFO='\033[0;32m'     # Green
    COLOR_WARN='\033[1;33m'     # Yellow
    COLOR_ERROR='\033[0;31m'    # Red
    COLOR_CRITICAL='\033[1;31m' # Bold Red
    COLOR_CONTEXT='\033[0;35m'  # Magenta
else
    COLOR_RESET=''
    COLOR_DEBUG=''
    COLOR_INFO=''
    COLOR_WARN=''
    COLOR_ERROR=''
    COLOR_CRITICAL=''
    COLOR_CONTEXT=''
fi

# ==================== Helper Functions ====================

# Get timestamp if enabled
_log_timestamp() {
    if [[ "$LOG_TIMESTAMP" == "true" ]]; then
        date '+%Y-%m-%d %H:%M:%S'
    fi
}

# Auto-detect context from caller
_log_detect_context() {
    local i=1   # skip current func
    local caller_file="unknown"
    local caller_func="main"
    local filename

    # Find the first caller outside of logger.sh and _utils.sh
    while [[ -n "${BASH_SOURCE[$i]}" ]]; do
        local current_file="${BASH_SOURCE[$i]}"
        local current_func="${FUNCNAME[$i]}"

        # If the current file is not logger.sh or _utils.sh, then it's our caller
        if [[ "$current_file" != *"/logger.sh"* && "$current_file" != *"/_utils.sh"* ]]; then
            caller_file="$current_file"
            caller_func="$current_func"
            break
        fi
        ((i++))
    done

    # Extract filename without path and extension
    filename=$(basename "$caller_file" .sh)

    # Determine if it's a lib function or main command
    if [[ "$caller_file" == *"/lib/myde/"* ]]; then
        # Library function - use function name if available
        if [[ "$caller_func" != "main" && "$caller_func" != "source" ]]; then
            echo "lib:${caller_func}"
        else
            echo "lib:${filename}"
        fi
    elif [[ "$filename" == "myde" ]]; then
        # Main myde command
        echo "myde"
    else
        # Other scripts
        echo "${filename}"
    fi
}

# Format log message with prefix
_log_format() {
    local level="$1"
    local context="$2"
    local message="$3"
    local color="$4"

    local timestamp=""

    [[ "$LOG_TIMESTAMP" == "true" ]] && timestamp="$(_log_timestamp) "

    if [[ -n "$context" ]]; then
        echo -e "${timestamp}${COLOR_CONTEXT}[${context}]${COLOR_RESET} ${color}${level}:${COLOR_RESET} ${message}"
    else
        echo -e "${timestamp}${color}${level}:${COLOR_RESET} ${message}"
    fi
}

# Write to log file if enabled
_log_to_file() {
    local message="$1"
    local clean_message

    if [[ -n "$LOG_FILE" ]]; then
        # Strip color codes for file output
        clean_message=$(echo -e "$message" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')

        echo "$clean_message" >> "$LOG_FILE"
    fi
}

# Send desktop notification
_log_notify() {
    local level="$1"
    local message="$2"
    local urgency="normal"
    local icon="dialog-information"

    # Skip if notifications disabled or notify-send not available
    [[ "$LOG_NOTIFY" != "true" ]] && return 0
    [[ -z "$NOTIFY_BIN" ]] && return 0

    # Set urgency and icon based on level
    case "$level" in
        CRITICAL|ERROR)
            urgency="critical"
            icon="dialog-error"
            ;;
        WARN)
            urgency="normal"
            icon="dialog-warning"
            ;;
        INFO|USAGE|SUCCESS)
            urgency="low"
            icon="dialog-information"
            ;;
        *)
            return 0  # Don't notify for debug
            ;;
    esac

    "$NOTIFY_BIN" -u "$urgency" -i "$icon" "MyDE" "$message" 2>/dev/null
}

# ==================== Core Logging Functions ====================


# Generic log function
# Usage: _log <level_num> <level_name> <color> <message> [options]
_log() {
    local level_num="$1"
    local level_name="$2"
    local color="$3"
    local message="$4" # The message is expected as a single argument here.
    local notify=false
    local custom_context=""

    shift 4 # Shift past level_num, level_name, color, and message

    # Parse options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n|--notify)
                notify=true
                shift
                ;;
            -c|--context)
                custom_context="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    # Check log level threshold
    [[ $level_num -lt $LOG_LEVEL ]] && return 0

    # Get context
    local context="${custom_context:-$(_log_detect_context)}"

    # Format message
    local formatted="$(_log_format "$level_name" "$context" "$message" "$color")"

    # Output to stderr for warnings and errors
    if [[ $level_num -ge 2 ]]; then
        echo -e "$formatted" >&2
    else
        echo -e "$formatted"
    fi

    # Write to log file
    _log_to_file "$formatted"

    # Send notification if requested or for critical errors
    if [[ "$notify" == "true" ]] || [[ $level_num -ge 4 ]]; then
        _log_notify "$level_name" "$message"
    fi
}

# ==================== Public API ====================

# Debug level (0) - Detailed information for debugging
log.debug() {
    _log 0 "DEBUG" "$COLOR_DEBUG" "$@"
}

# Info level (1) - General informational messages
log.info() {
    _log 1 "INFO" "$COLOR_INFO" "$@"
}

# Success message (always shown, info level)
log.success() {
    _log 1 "SUCCESS" "$COLOR_INFO" "$@"
}

# Show Usage message (info level)
log.usage() {
    _log 1 "USAGE" "$COLOR_INFO" "$message"
}

# Warning level (2) - Warning messages
log.warn() {
    _log 2 "WARN" "$COLOR_WARN" "$@"
}

# Error level (3) - Error messages
log.error() {
    _log 3 "ERROR" "$COLOR_ERROR" "$@"
}

# Critical level (4) - Critical errors (auto-notifies)
log.critical() {
    _log 4 "CRITICAL" "$COLOR_CRITICAL" "$@"
}


# ==================== Convenience Functions ====================

# Log with custom context (for when auto-detection isn't suitable)
log.with_context() {
    local context="$1"
    local level="$2"
    shift 2

    case "$level" in
        debug)    log.debug -c "$context" "$@" ;;
        info)     log.info -c "$context" "$@" ;;
        warn)     log.warn -c "$context" "$@" ;;
        error)    log.error -c "$context" "$@" ;;
        critical) log.critical -c "$context" "$@" ;;
        *)        log.info -c "$context" "$@" ;;
    esac
}

# Set log level dynamically
log.set_level() {
    case "$1" in
        debug)    LOG_LEVEL=0 ;;
        info)     LOG_LEVEL=1 ;;
        warn)     LOG_LEVEL=2 ;;
        error)    LOG_LEVEL=3 ;;
        critical) LOG_LEVEL=4 ;;
        *)
            echo "Invalid log level: $1" >&2
            echo "Valid levels: debug, info, warn, error, critical" >&2
            return 1
            ;;
    esac
}

# Enable/disable colored output
log.set_color() {
    case "$1" in
        on|true|1)  LOG_COLOR=true ;;
        off|false|0) LOG_COLOR=false ;;
        *)
            echo "Usage: log.set_color {on|off}" >&2
            return 1
            ;;
    esac
}

# Enable/disable timestamps
log.set_timestamp() {
    case "$1" in
        on|true|1)  LOG_TIMESTAMP=true ;;
        off|false|0) LOG_TIMESTAMP=false ;;
        *)
            echo "Usage: log.set_timestamp {on|off}" >&2
            return 1
            ;;
    esac
}

# Set log file
log.set_log_file() {
    LOG_FILE="$1"

    # Create log directory if needed
    if [[ -n "$LOG_FILE" ]]; then
        local log_dir=$(dirname "$LOG_FILE")
        mkdir -p "$log_dir" 2>/dev/null
    fi
}

# ==================== Export Functions ====================

# Export internal helper functions for subshell compatibility
export -f _log_timestamp _log_detect_context _log_format _log_to_file _log_notify _log

# Export all public functions for use in other scripts
export -f log.debug log.info log.warn log.error log.critical log.success
export -f log.with_context log.usage log.set_level log.set_color
export -f log.set_timestamp log.set_log_file

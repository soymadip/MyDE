#
#    _______| |__   ___ _ ____   __
#   |_  / __| '_ \ / _ \ '_ \ \ / /
#  _ / /\__ \ | | |  __/ | | \ V /
# (_)___|___/_| |_|\___|_| |_|\_/
#
# Environment variables that must exist everywhere.
# ONLY SOURCED IN LOGIN time.

# ------------ XDG Base Directories ------------

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_MENU_PREFIX="arch-"


# ----------- Cleanup home dir --------------

export HISTFILE="$XDG_DATA_HOME/zsh/history"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"
export GOPATH="$XDG_DATA_HOME/go"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export PNPM_HOME="$XDG_DATA_HOME/pnpm"


#------------ Setup PATH --------------

# Make sure PATH is unique and sorted
typeset -gU path PATH
path=(
    "$XDG_DATA_HOME/kireisakura-kit/bin"
    "$HOME/.local/bin"
    "$GOPATH/bin"
    "$PNPM_HOME"
    $path
)
export PATH


#--------------- Enable wayland --------------

export GDK_BACKEND="wayland,x11,*"

export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME=qt6ct

export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland

export ELECTRON_OZONE_PLATFORM_HINT=auto


#-------------- Disable csd --------------

export QT_WAYLAND_DISABLE_WINDOWDECORATION=1


#---------------- Cursor ----------------

if [[ -z "$_CURSOR_SIZE" ]]; then
    if (( ${+commands[myctl]} )); then
        _CURSOR_SIZE=$(myctl get cursor size 2>/dev/null)
    fi
    : "${_CURSOR_SIZE:=24}"
fi

export HYPRCURSOR_SIZE="$_CURSOR_SIZE"
export XCURSOR_SIZE="$_CURSOR_SIZE"
export QT_CURSOR_SIZE="$_CURSOR_SIZE"


#---------------- EDITOR ----------------

if [[ -z "$EDITOR" ]]; then
    for edtr in nvim helix vim vi nano; do
        if (( ${+commands[$edtr]} )); then
            export EDITOR="$edtr"
            break
        fi
    done
fi

if [[ -z "$VISUAL" ]]; then
    for vised in zeditor code codium "$EDITOR"; do
        if [[ -n "$vised" ]] && (( ${+commands[$vised]} )); then
            export VISUAL="$vised"
            break
        fi
    done
fi

export SUDO_EDITOR="$EDITOR"


#---------------- TERMINAL ----------------

if [[ -z "$TERMINAL" ]]; then
    if (( ${+commands[myctl]} )); then
        _term_name=$(myctl get hconf terminal)

        export TERMINAL="$_term_name"

        if _term_desktop="$(myctl get desktop-filename "$_term_name")"; then
            handlr set x-scheme-handler/terminal "$_term_desktop" &>/dev/null

            if (( ${+commands[kwriteconfig6]} )); then
                kwriteconfig6 --file "$HOME/.config/kdeglobals" --group General --key TerminalService "$_term_desktop"
            fi
        else
            notify-send "Terminal Sync Error" "Failed to get desktop file for $_term_name"
        fi
    fi
fi


#---------------- Misc ------------------

# Allow Nix Unfree pckgs
export NIXPKGS_ALLOW_UNFREE=1


#============ Define custom config dir ===============
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

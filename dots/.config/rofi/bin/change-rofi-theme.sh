#!/usr/bin/env bash
#
#  ____        __ _
# |  _ \ ___  / _(_)
# | |_) / _ \| |_| |
# |  _ < (_) |  _| |
# |_| \_\___/|_| |_|
#
# Change Theme for Rofi.


#============ User Config ============#

_THEME_NAME="catppuccin-macchiato"

_FONT_SIZE="11.2"
_FONT_NAME="FiraCode Nerd Font"
_BOLD_FONT_NAME="JetBrainsMono Nerd Font ExtraBold"


_CONFIG_DIR="$HOME/.config/rofi"
_CONFIG_PATH="$_CONFIG_DIR/config.rasi"


#========= Build Config & Inject to Rofi Config =========#


[ ! -f "$_CONFIG_DIR"/colors/"$_THEME_NAME".rasi ] && {
    echo "Couldn't find Theme: '$_THEME_NAME' in $_CONFIG_DIR/colors/"
    exit 1
}

cat > "${_CONFIG_PATH}" << EOF

@import "~/.config/rofi/colors/${_THEME_NAME}.rasi"

* {
    font: "${_FONT_NAME} ${_FONT_SIZE}";
    font-bold: "${_BOLD_FONT_NAME} ${_FONT_SIZE}";

    border-radius: 6px;
}
EOF

echo "Theme configuration written to ${_CONFIG_PATH}"

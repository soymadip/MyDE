#!/usr/bin/env bash
#
# Parse keybinds file and show in rofi.
# Also handles splitting keybinds with slashes intelligently.
#
# Use <!-- SKIP_START --> and <!-- SKIP_END --> to skip sections in the keybinds.md

KEYBINDS_FILE="$1"
PROMPT_TEXT="Keybinds Help"
THEME_FILE="$HOME/.config/rofi/conf/keybinds-menu.rasi"

# ================ Parsing Logic ================
KEYBINDS=$(
  awk -f /dev/stdin "$KEYBINDS_FILE" <<'EOF'
            # Function to apply common keybind cleanup
            function clean_key(k) {
                gsub(/ \+ /, "+", k)
                gsub(/^\s+|\s+$/, "", k)
                return k
            }

            # Function to escape HTML entities for Pango markup
            function escape_html(text) {
                gsub(/&/, "\\&amp;", text)
                gsub(/</, "\\&lt;", text)
                gsub(/>/, "\\&gt;", text)
                return text
            }

            # Function to print a separator line (an empty row)
            function print_spacer() {
                print ""
            }

            # Variable to track if we're in a skip section
            BEGIN {
                skip_section = 0
            }

            # Check for skip comments
            /^<!-- SKIP_START -->/ {
                skip_section = 1
                next
            }

            /^<!-- SKIP_END -->/ {
                skip_section = 0
                next
            }

            # Skip everything when in skip section
            skip_section == 1 {
                next
            }

            # --- Structural Logic ---
            /^## / {
                # Print the spacer *before* the new category starts.
                print_spacer()
                next
            }

            # Skip non-data lines
            /^\s*---/ { next }
            /^\s*$/ { next }
            /^\s*\| *:---/ { next }
            /^\s*\| Keys/ { next }
            /^\s*\| Keybind/ { next }

            # Process the table rows
            /^\s*\| / {
                line = $0

                # --- Data Extraction ---
                gsub(/^\s*\|\s*/, "", line)
                gsub(/\s*\|\s*$/, "", line)
                split(line, fields, /\|/)

                keybind_raw = fields[1]
                action = fields[2]

                # --- Cleanup Action String and CRITICAL Validity Check ---
                action_cleaned = action
                gsub(/\*\*/, "", action_cleaned)
                gsub(/\s{2,}/, " ", action_cleaned)
                gsub(/^\s+|\s+$/, "", action_cleaned)
                gsub(/\*+/, "", action_cleaned)

                # CRITICAL CHECK: If action is empty or junk, skip the line completely.
                # This explicitly filters the lines that are causing the corruption.
                if (length(action_cleaned) < 5) {
                    next
                }

                # --- Keybind Cleanup (Base) ---
                keybind_raw_cleaned = keybind_raw
                gsub(/`|<br>|&nbsp;|\s{2,}/, " ", keybind_raw_cleaned)

                # --- DYNAMIC SPLIT LOGIC ---
                # Only split if it's an alternative keybind format (like "Volume Up / Volume Down")
                # Don't split if the slash is part of the actual keybind (like "Super + /")
                if (keybind_raw_cleaned ~ /\//) {
                    first_key = keybind_raw_cleaned
                    sub(/\/.*/, "", first_key)
                    first_key = clean_key(first_key)

                    second_key = keybind_raw_cleaned
                    sub(/[^/]*\/\s*/, "", second_key)
                    second_key = clean_key(second_key)

                    # Check if this is a real split (both parts have content) or just a keybind with slash
                    if (length(first_key) > 0 && length(second_key) > 0) {
                        first_key_clean = first_key
                        first_key = escape_html(first_key)
                        action_cleaned = escape_html(action_cleaned)

                        # Calculate padding based on clean text length, not markup
                        padding1 = 30 - length(first_key_clean)
                        spaces1 = ""
                        for (i = 0; i < padding1; i++) {
                            spaces1 = spaces1 " "
                        }
                        printf "<b>%s</b>%s %s\n", first_key, spaces1, action_cleaned

                        second_key_clean = second_key
                        second_key = escape_html(second_key)
                        # Calculate padding based on clean text length, not markup
                        padding2 = 30 - length(second_key_clean)
                        spaces2 = ""
                        for (i = 0; i < padding2; i++) {
                            spaces2 = spaces2 " "
                        }
                        printf "<b>%s</b>%s %s\n", second_key, spaces2, action_cleaned
                    } else {
                        # This is a keybind containing slash, treat as single keybind
                        keybind = clean_key(keybind_raw_cleaned)
                        keybind_clean = keybind
                        keybind = escape_html(keybind)
                        action_cleaned = escape_html(action_cleaned)

                        # Calculate padding based on clean text length, not markup
                        padding = 30 - length(keybind_clean)
                        spaces = ""
                        for (i = 0; i < padding; i++) {
                            spaces = spaces " "
                        }
                        printf "<b>%s</b>%s %s\n", keybind, spaces, action_cleaned
                    }
                } else {
                    # --- NO SPLIT: Standard Logic ---
                    keybind = clean_key(keybind_raw_cleaned)
                    keybind_clean = keybind
                    keybind = escape_html(keybind)
                    action_cleaned = escape_html(action_cleaned)

                    # Calculate padding based on clean text length, not markup
                    padding = 30 - length(keybind_clean)
                    spaces = ""
                    for (i = 0; i < padding; i++) {
                        spaces = spaces " "
                    }
                    printf "<b>%s</b>%s %s\n", keybind, spaces, action_cleaned
                }
            }
EOF
)

# ================ Display Rofi ================

echo -e "$KEYBINDS" | rofi \
  -dmenu \
  -i \
  -markup-rows \
  -p "$PROMPT_TEXT" \
  -theme "$THEME_FILE"

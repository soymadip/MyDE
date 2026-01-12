#!/bin/bash

# Usage: play-sound.sh <VOLUME> [<SOUND_NAME>|-f <FILE_PATH>]

SOUND_DIR="/usr/share/sounds/freedesktop/stereo"

_elog() {
  echo "Usage: $0 <VOLUME> [<SOUND_NAME>|-f <FILE_PATH>]" >&2
  exit 1

}

[[ "$#" -eq 0 ]] && {
  _elog
}

VOLUME="0.7"
shift

while [[ "$#" -gt 0 ]]; do
  case $1 in
  -f | --file)
    [[ -z "$1" ]] && _elog
    FILE="${2}.oga"
    shift 2
    ;;
  "")
    _elog
    ;;
  *)
    FILE="$SOUND_DIR/$1.oga"
    shift
    ;;
  esac
done

if [[ ! -f "$FILE" ]]; then
  echo "Error: Sound file '$FILE' does not exist." >&2
  exit 1
fi

echo "Playing sound: $FILE at volume: $VOLUME" >&2

# 1. Check for the suppress hint.
if [[ "${SWAYNC_HINT_suppress_sound}" == "true" ]] || [[ "$SWAYNC_HINT_suppress_sound" == "1" ]]; then
  exit 0
fi

# 3. Play the sound
pw-play --volume "$VOLUME" --media-role event "$FILE"

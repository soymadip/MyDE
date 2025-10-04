#!/usr/bin/env bash

#TODO: Port to KireiSakura Kit
# eval "$(kireisakura -i)"

current_dir=$(basename "$(pwd)")

[ "$current_dir" != "MyDE" ] && echo "Please Run Installer within the MyDE dir root." && exit 1

ln -s src/.directory .directory

stow -v -d dots -t "$HOME" .

echo "done"

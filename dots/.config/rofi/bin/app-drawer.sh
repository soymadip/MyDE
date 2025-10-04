#!/usr/bin/env bash

theme_file="$HOME/.config/rofi/conf/app-drawer.rasi"

## Run
rofi \
  -show drun \
  -theme "${theme_file}"

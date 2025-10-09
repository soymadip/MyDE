#!/bin/env bash


cursor_name="$(hypr-gtkconf get cursor-theme)"
cursor_size="$(hypr-gtkconf get cursor-size)"

hyprctl setcursor $cursor_name $cursor_size

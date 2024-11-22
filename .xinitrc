#!/bin/sh

# disable sleep
xset s off
xset -dpms

# Set correct keyboard layout
setxkbmap dk

# start i3
exec i3

#!/bin/sh

# disable sleep
xset s off
xset -dpms

# Set correct keyboard layout
setxkbmap dk -option numpad:pointerkeys
# might need to install xkbset.
# On debian there's a apt package.
# On arch it's aur. You can't use pacman for that,
# but you could install yay
xkbset ma 10 10 3000 200 10

# start i3
exec i3

#!/bin/sh
file="$HOME/.window_key"

if [ ! -f "$file" ]; then
    touch $file;
    xdotool getwindowfocus windowsize 70% 80% ; xdotool getwindowfocus windowmove 15% 10%;
else
    rm $file;
    xdotool getwindowfocus windowsize 100% 100% ; xdotool getwindowfocus windowmove 0 0 ;
fi

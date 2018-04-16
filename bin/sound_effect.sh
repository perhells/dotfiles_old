#!/usr/bin/env bash

count=$(ls /usr/local/share/soundeffects | grep -v ".*\.disabled" | wc -l)
num=$(( ( RANDOM % count ) + 1 ))
sound=$(ls /usr/local/share/soundeffects | grep -v ".*\.disabled" | tail -n "$num"  | head -n 1)

mplayer "/usr/local/share/soundeffects/$sound"

#!/bin/sh

command=
unused_increment=
increment=8

while getopts "c:i" o
do case "$o" in
    c) command=$OPTARG;;
    i) increment=$OPTARG;;
esac
done

if [ "$command" = "up" ]; then
    $(xbacklight -inc $increment)
else
	if [ "$command" = "down" ]; then
        $(xbacklight -dec $increment)
	fi
fi

display_brightness=$(xbacklight)

icon_name="display-brightness-symbolic"

notify-send " " -i $icon_name -h int:value:$display_brightness -h string:synchronous:brightness

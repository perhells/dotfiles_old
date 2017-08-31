#!/bin/sh
# Original discussion, see https://bbs.archlinux.org/viewtopic.php?id=69589
# Updated and improved by Per Hellström, perhellsing@gmail.com

usage="$0 Version $version Help\nDependencies: libnotify, alsa-utils\nusage:\n\t $0  [OPTIONS] -c COMMAND \nCOMMAND:\n-c\tup \n\t\t(increase volume by increment)\n\tdown \n\t\t(decrease volume by increment)\n\tmute \n\t\t(mute volume) \n\nOPTIONS:\n-i\tincrement \n\t\t(the amount of db to increase/decrease)[default:2500] \n-m\tmixer \n\t\t(the device to change)[default:Master]"

command=
increment=4
mixer="Master"

while getopts "c:i:m:h" o
do case "$o" in
    c) command=$OPTARG;;
    i) increment=$OPTARG;;
    m) mixer=$OPTARG;;
    h) echo -e "$usage"; exit 0;;
    ?) echo -e "$usage"; exit 0;;
esac
done

current_volume=$(amixer get Master | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
icon_name=""
if [ "$command" = "up" ]; then
    target_volume=$(($current_volume + increment))
    if [ "$target_volume" -gt "$((100-increment))" ]; then
        target_volume=100
    fi
    amixer set $mixer $target_volume% unmute > /dev/null
else
	if [ "$command" = "down" ]; then
        target_volume=$(($current_volume - increment))
        if [ "$target_volume" -lt "$increment" ]; then
            target_volume=0
        fi
        amixer set $mixer $target_volume% unmute > /dev/null
	else
		if [ "$command" = "mute" ]; then
		    if amixer get Master | grep "\[on\]"; then
                target_volume=0
                icon_name="notification-audio-volume-muted"
                amixer set $mixer mute
            else
                target_volume=$(amixer set $mixer unmute | grep -m 1 "%]" | cut -d "[" -f2|cut -d "%" -f1)
		    fi
		else
            if [ "$command" = "set" ]; then
                target_volume=$increment
                amixer set $mixer $target_volume% unmute > /dev/null
            else
                echo -e $usage
            fi
        fi
	fi
fi

if [ "$icon_name" = "" ]; then
    if [ "$target_volume" = "0" ]; then
        icon_name="notification-audio-volume-off"
    else
        if [ "$target_volume" -lt "33" ]; then
            icon_name="notification-audio-volume-low"
        else
            if [ "$target_volume" -lt "67" ]; then
                icon_name="notification-audio-volume-medium"
            else
                icon_name="notification-audio-volume-high"
            fi
        fi
    fi
fi

paplay /usr/share/sounds/gnome/default/alerts/drip.ogg &

notify-send " " -i $icon_name -h int:value:$target_volume -h string:synchronous:volume
echo $target_volume

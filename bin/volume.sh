#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

libnotify_id=1

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=$(get_volume)
    if [ $volume -eq "0" ]; then
        icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-off.svg"
    else
        if [ $volume -lt "33" ]; then
            icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-low.svg"
        else
            if [ $volume -lt "66" ]; then
                icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-medium.svg"
            else
                icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-high.svg"
            fi
        fi
    fi
    if [ $volume -lt "10" ]; then
        space="      "
    else
        if [ $volume -lt "100" ]; then
            space="     "
        else
            space="    "
        fi
    fi
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    dunstify -i "$icon_name" -r "$libnotify_id" "$volume$space$bar" 
}

case $1 in
    up)
	# Set the volume on (if it was muted)
	amixer -D pulse set Master on > /dev/null
	# Up the volume (+ 5%)
	amixer -D pulse sset Master 5%+ > /dev/null
	send_notification
	;;
    down)
	amixer -D pulse set Master on > /dev/null
	amixer -D pulse sset Master 5%- > /dev/null
	send_notification
	;;
    max)
	amixer -D pulse set Master on > /dev/null
	amixer -D pulse sset Master 100% > /dev/null
	send_notification
	;;
    min)
	amixer -D pulse set Master on > /dev/null
	amixer -D pulse sset Master 0% > /dev/null
	send_notification
	;;
    mute)
    	# Toggle mute
	amixer -D pulse set Master 1+ toggle > /dev/null
	if is_mute ; then
            icon_name="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-off.svg"
	    dunstify -i "$icon_name" -r "$libnotify_id" "Mute"
	else
	    send_notification
	fi
	;;
esac

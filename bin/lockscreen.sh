#!/bin/bash
scrot /tmp/screenshot.png
convert /tmp/screenshot.png -filter Gaussian -resize 20% -define filter:sigma=2.5 -resize 500% /tmp/screenshotblur.png
i3lock -i /tmp/screenshotblur.png

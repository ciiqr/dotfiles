#!/usr/bin/env bash

# Toggle
xdotool key Caps_Lock

# if -v param is supplied
if [ "$1" = "-v" ]; then
	# If Caps Lock in on
	if xset -q | grep "Caps Lock: *on" 1>/dev/null; then
		# Going to Switch it off
		echo "On"
	else
		# Going to Switch it on
		echo "Off"
	fi
fi

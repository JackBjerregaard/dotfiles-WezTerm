#!/usr/bin/env bash

WIFI_DEVICE=$(networksetup -listallhardwareports 2>/dev/null | awk '
	/Hardware Port: (Wi-Fi|AirPort)/ {
		getline
		sub("Device: ", "")
		print
		exit
	}
')

if [ -z "$WIFI_DEVICE" ]; then
	WIFI_DEVICE="en0"
fi

WIFI_POWER=$(networksetup -getairportpower "$WIFI_DEVICE" 2>/dev/null | awk '{print $NF}')
WIFI_STATUS=$(ifconfig "$WIFI_DEVICE" 2>/dev/null | awk '/status: / { print $2 }')
WIFI_IP=$(ifconfig "$WIFI_DEVICE" 2>/dev/null | awk '/inet / { print $2; exit }')

if [ "$WIFI_POWER" = "On" ] && [ "$WIFI_STATUS" = "active" ] && [ -n "$WIFI_IP" ]; then
	ICON="󰤨"
else
	ICON="󰤭"
fi

sketchybar --set "$NAME" icon="$ICON"

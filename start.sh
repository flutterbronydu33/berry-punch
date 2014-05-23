#!/usr/bin/env bash

[[ -f /usr/bin/supybot ]] || {
	echo "Error: Supybot package needed.";
	exit 1;
}

supybot BerryPunch.conf

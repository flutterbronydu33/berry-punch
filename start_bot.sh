#!/usr/bin/env bash

[[ -f /usr/bin/supybot ]] || {
	echo "Error: Supybot package needed.";
	exit 1;
}

tmux new -ds ircbot 'supybot /home/berry-punch/BerryPunch.conf'

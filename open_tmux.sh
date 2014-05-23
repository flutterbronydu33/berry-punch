#!/usr/bin/env bash
echo "Tapez Ctrl-B puis d pour sortir";
echo "(appuyer sur n'importe quelle touche pour continuer)"
read a;
tmux attach -t ircbot

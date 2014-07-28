#!/usr/bin/env bash

cat old_logs/#bronycub.$(date +%Y%m)* \#bronycub.log |\
	sed 's/\(^[0-9]*-[0-9]*-[0-9]*T[0-9]*:[0-9]*:[0-9]*  \?\)\(<[^>]*>\)\(.*\)/\1[32m\2[0m\3/' |\
	sed 's/\(^[0-9]*-[0-9]*-[0-9]*T[0-9]*:[0-9]*:[0-9]*  \?\)\(\*\(\*\*\)\?.*$\)/\1[33m\2[0m/' |\
	less -cNRS

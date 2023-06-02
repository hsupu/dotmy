#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
	error_echo "required to run as root" 1
fi

echo 1 > /proc/sys/vm/drop_caches
echo "$info: memory reclaimed."


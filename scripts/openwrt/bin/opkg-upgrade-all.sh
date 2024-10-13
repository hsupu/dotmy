#!/usr/bin/env sh

# opkg list-upgradable | awk '{ print $1 }' | xargs opkg upgrade
opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade

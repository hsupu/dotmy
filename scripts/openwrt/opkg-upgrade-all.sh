#!/usr/bin/env sh

opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade

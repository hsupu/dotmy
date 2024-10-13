#!/usr/bin/env bash

BASE=Generic
PKGS=" \
	iptables-mod-tproxy \
	curl wget \
	htop lsof \
	tmux \
	luci-i18n-wol-en luci-i18n-upnp-en \
"

make image \
	PROFILE=$BASE \
	PACKAGES="$PKGS" \
	FILES=files/


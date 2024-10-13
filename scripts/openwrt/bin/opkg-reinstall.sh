#!/usr/bin/env ash

opkg update

opkg install \
    iptables-nft ip6tables-nft \
	ip6tables-mod-nat iptables-mod-tproxy \
	curl wget htop lsof \
	openssh-sftp-server \
	miniupnpd-nftables luci-app-upnp luci-i18n-upnp-en \
	luci-app-wol luci-i18n-wol-en \
	tmux

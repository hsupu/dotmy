#!/usr/bin/env bash

PROFILE=phicomm-k3

PACKAGES=" \
	kernel base-files libc libgcc \
	kmod-gpio-button-hotplug kmod-ipt-offload kmod-leds-gpio kmod-ledtrig-default-on kmod-ledtrig-timer \
	busybox dnsmasq dropbear firewall fstools iptables ip6tables ip6tables-mod-nat logd luci luci-theme-bootstrap mtd netifd nvram odhcpd-ipv6only odhcp6c opkg ppp ppp-mod-pppoe swconfig uci uclient-fetch urandom-seed urngd \
	osafeloader oseama otrx \
	iwinfo wpad-basic kmod-brcmfmac kmod-brcmutil kmod-cfg80211 brcmfmac-firmware-4366c0-pcie \
	kmod-scsi-core kmod-usb-ohci kmod-usb2 kmod-phy-bcm-ns-usb2 kmod-usb3 kmod-phy-bcm-ns-usb3 kmod-usb-ledtrig-usbport \
	block-mount blockd mount-utils ntfs-3g \
	curl htop tmux wget \
	iftop iperf3 lsof \
	minidlna luci-i18n-minidlna-en \
	luci-i18n-openvpn-en \
	samba4-server luci-i18n-samba4-en \
	ttyd luci-i18n-ttyd-en \
	miniupnpd luci-i18n-upnp-en \
	etherwake luci-i18n-wol-en \
	"

make image \
	PROFILE=$PROFILE \
	PACKAGES="$PACKAGES" \
	FILES=files/

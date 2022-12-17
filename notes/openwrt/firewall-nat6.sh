
WAN_IF=eth0.2
LAN_IF=br-lan

LAN6_SEG=fd00:7870:12::/48
LAN6_GATEWAY=fd00:7870:12::1

LAN4_SEG=192.168.12.0/24
LAN4_GATEWAY=192.168.12.2

#iptables -A input_wan_rule -j DROP
#iptables -t nat -A postrouting_rule -o lo -j RETURN

ip6tables -A input_wan_rule -s 2400:dd01:100f:5f92::/64 -j ACCEPT
ip6tables -A input_wan_rule -s 2400:dd01:100f:5fb3::/64 -j ACCEPT
ip6tables -A input_wan_rule -s 2001::/8 -j ACCEPT
ip6tables -A input_wan_rule -s 2400::/8 -j ACCEPT

ip6tables -t nat -N stat
ip6tables -t nat -F stat
ip6tables -t nat -A stat -s 2001:cc0:2020::/48 -j RETURN
ip6tables -t nat -A stat -s $LAN6_SEG -j RETURN

## ==== nat6 ====
## requires ipt-nat6
#ip6tables -t nat -A POSTROUTING -j stat
ip6tables -t nat -A POSTROUTING -o $WAN_IF -j MASQUERADE

WAN_IF=wan
LAN_IF=br-lan

SS_DIRECTS=13.75.111.64,194.156.121.172,104.128.89.135,207.148.115.155,45.77.22.132
SS_PORT=1088
DNS_PORT=5353

iptables -t nat -N ss
iptables -t nat -F ss
iptables -t nat -A ss -d 0.0.0.0/8 -j RETURN # source only
iptables -t nat -A ss -d 127.0.0.0/8 -j RETURN # loopback
iptables -t nat -A ss -d 10.0.0.0/8 -j RETURN # A-private
iptables -t nat -A ss -d 169.254.0.0/16 -j RETURN # link-local
iptables -t nat -A ss -d 172.16.0.0/12 -j RETURN # B-private
iptables -t nat -A ss -d 192.0.0.0/24 -j RETURN # reserved
iptables -t nat -A ss -d 192.0.2.0/24 -j RETURN # test
iptables -t nat -A ss -d 192.168.0.0/16 -j RETURN # C-private
iptables -t nat -A ss -d 198.51.100.0/24 -j RETURN # test
iptables -t nat -A ss -d 203.0.113.0/24 -j RETURN # test
iptables -t nat -A ss -d 224.0.0.0/4 -j RETURN # multicast
iptables -t nat -A ss -d 240.0.0.0/4 -j RETURN # reserved
iptables -t nat -A ss -d 255.255.255.255 -j RETURN # boardcast

# uncommit next two lines if ss-server is listening on a IPv4 address
iptables -t nat -A ss -d $SS_DIRECTS -j RETURN

# ss-local should be running on the router and listening on 0.0.0.0
iptables -t nat -A ss -p tcp -j REDIRECT --to-port $SS_PORT

iptables -t mangle -N ss
iptables -t mangle -F ss
iptables -t mangle -A ss -d 0.0.0.0/8 -j RETURN # source only
iptables -t mangle -A ss -d 127.0.0.0/8 -j RETURN # loopback
iptables -t mangle -A ss -d 169.254.0.0/16 -j RETURN # link-local
iptables -t mangle -A ss -d 10.0.0.0/8 -j RETURN # A-private
iptables -t mangle -A ss -d 172.16.0.0/12 -j RETURN # B-private
iptables -t mangle -A ss -d 192.0.0.0/24 -j RETURN # reserved
iptables -t mangle -A ss -d 192.0.2.0/24 -j RETURN # test
iptables -t mangle -A ss -d 192.168.0.0/16 -j RETURN # C-private
iptables -t mangle -A ss -d 198.51.100.0/24 -j RETURN # test
iptables -t mangle -A ss -d 203.0.113.0/24 -j RETURN # test
iptables -t mangle -A ss -d 224.0.0.0/4 -j RETURN # multicast
iptables -t mangle -A ss -d 240.0.0.0/4 -j RETURN # reserved
iptables -t mangle -A ss -d 255.255.255.255 -j RETURN # boardcast

# uncommit next two lines if ss-server is listening on a IPv4 address
iptables -t mangle -A ss -d $SS_DIRECTS -j RETURN

# do TPROXY and add fwmark 0x1 to packets
# ss-local should be running on the router and listening on 127.0.0.1 / 0.0.0.0
iptables -t mangle -A ss -p udp -j TPROXY --tproxy-mark 0x1/0x1 --on-ip 127.0.0.1 --on-port $SS_PORT

# routing rule:
#   for packet with fwmark 0x1, look up table 100
#   for table 100, route to "local" through device "lo" by default
ip -4 rule del fwmark 0x1 lookup 100
ip -4 rule add fwmark 0x1 lookup 100
ip -4 route del local default dev lo table 100
ip -4 route add local default dev lo table 100

# for udp, it's better to accept all input from each ip address of ss-server, because udp conntrack doesn't work well
iptables -A input_wan_rule -p tcp -i $WAN_IF -s $SS_DIRECTS -j ACCEPT
iptables -A input_wan_rule -p udp -i $WAN_IF -s $SS_DIRECTS -j ACCEPT

iptables -t nat -A prerouting_lan_rule -i $LAN_IF -p tcp -j ss
iptables -t mangle -A PREROUTING -i $LAN_IF -p udp -j ss

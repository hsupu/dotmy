
WAN_IF=eth0.2
LAN_IF=br-lan

#iptables -A input_wan_rule -j DROP
#iptables -t nat -A postrouting_rule -o lo -j RETURN

## ==== transparent proxy ====
SS_IP=0.0.0.0
SS_PORT=1088

iptables -t nat -N ss
iptables -t nat -F ss
iptables -t nat -A ss -d 0.0.0.0/8 -j RETURN # source only
iptables -t nat -A ss -d 127.0.0.0/8 -j RETURN # loopback
iptables -t nat -A ss -d 169.254.0.0/16 -j RETURN # link-local
iptables -t nat -A ss -d 10.0.0.0/8 -j RETURN # A-private
iptables -t nat -A ss -d 172.16.0.0/12 -j RETURN # B-private
iptables -t nat -A ss -d 192.0.0.0/24 -j RETURN # reserved
iptables -t nat -A ss -d 192.0.2.0/24 -j RETURN # test
iptables -t nat -A ss -p tcp -d 192.168.13.0/24 -j REDIRECT --to-port $SS_PORT # DNAT --to $SS_IP:$SS_PORT
iptables -t nat -A ss -d 192.168.0.0/16 -j RETURN # C-private
iptables -t nat -A ss -d 198.51.100.0/24 -j RETURN # test
iptables -t nat -A ss -d 203.0.113.0/24 -j RETURN # test
iptables -t nat -A ss -d 224.0.0.0/4 -j RETURN # multicast
iptables -t nat -A ss -d 240.0.0.0/4 -j RETURN # reserved
iptables -t nat -A ss -d 255.255.255.255 -j RETURN # boardcast
# add IPv4 address of ss-server here
iptables -t nat -A ss -p tcp -j REDIRECT --to-port $SS_PORT # DNAT --to $SS_IP:$SS_PORT

iptables -t mangle -N ss
iptables -t mangle -F ss
iptables -t mangle -A ss -d 0.0.0.0/8 -j RETURN # source only
iptables -t mangle -A ss -d 127.0.0.0/8 -j RETURN # loopback
iptables -t mangle -A ss -d 169.254.0.0/16 -j RETURN # link-local
iptables -t mangle -A ss -d 10.0.0.0/8 -j RETURN # A-private
iptables -t mangle -A ss -d 172.16.0.0/12 -j RETURN # B-private
iptables -t mangle -A ss -d 192.0.0.0/24 -j RETURN # reserved
iptables -t mangle -A ss -d 192.0.2.0/24 -j RETURN # test
iptables -t mangle -A ss -p udp -d 192.168.13.0/24 -j TPROXY --tproxy-mark 0x08/0x08 --on-ip $SS_IP --on-port $SS_PORT
iptables -t mangle -A ss -d 192.168.0.0/16 -j RETURN # C-private
iptables -t mangle -A ss -d 198.51.100.0/24 -j RETURN # test
iptables -t mangle -A ss -d 203.0.113.0/24 -j RETURN # test
iptables -t mangle -A ss -d 224.0.0.0/4 -j RETURN # multicast
iptables -t mangle -A ss -d 240.0.0.0/4 -j RETURN # reserved
iptables -t mangle -A ss -d 255.255.255.255 -j RETURN # boardcast
# add IPv4 address of ss-server here
iptables -t mangle -A ss -p udp --dport 53 -j RETURN # dns
iptables -t mangle -A ss -p udp -j TPROXY --tproxy-mark 0x08/0x08 --on-ip $SS_IP --on-port $SS_PORT

ip -4 rule del fwmark 0x08 lookup 100
ip -4 rule add fwmark 0x08 lookup 100
ip -4 route del local default dev lo table 100
ip -4 route add local default dev lo table 100

iptables -t nat -A prerouting_lan_rule -p tcp -j ss
iptables -t mangle -A PREROUTING -i $LAN_IF -p udp -j ss

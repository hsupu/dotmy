
## ==== dns interception ===
DNS_SRC_PORT=53
DNS_DST_PORT=53

iptables -t nat -N dns
iptables -t nat -F dns
iptables -t nat -A dns -d 0.0.0.0/8 -j RETURN # source only
iptables -t nat -A dns -d 127.0.0.0/8 -j RETURN # loopback
iptables -t nat -A dns -d 169.254.0.0/16 -j RETURN # link-local
iptables -t nat -A dns -d 10.0.0.0/8 -j RETURN # A-private
iptables -t nat -A dns -d 172.16.0.0/12 -j RETURN # B-private
iptables -t nat -A dns -d 192.0.0.0/24 -j RETURN # reserved
iptables -t nat -A dns -d 192.0.2.0/24 -j RETURN # test
iptables -t nat -A dns -d 192.168.0.0/16 -j RETURN # C-private
iptables -t nat -A dns -d 198.51.100.0/24 -j RETURN # test
iptables -t nat -A dns -d 203.0.113.0/24 -j RETURN # test
iptables -t nat -A dns -d 224.0.0.0/4 -j RETURN # multicast
iptables -t nat -A dns -d 240.0.0.0/4 -j RETURN # reserved
iptables -t nat -A dns -d 255.255.255.255 -j RETURN # boardcast
# add IPv4 address of dns-server here
iptables -t nat -A dns -p udp -j REDIRECT --to-ports $DNS_DST_PORT

#iptables -t nat -A prerouting_lan_rule -p udp --dport $DNS_SRC_PORT -j dns

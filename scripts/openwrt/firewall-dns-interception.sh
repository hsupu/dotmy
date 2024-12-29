
iptables -t nat -A zone_lan_prerouting -p udp --dport 53 -j REDIRECT --to-port $DNS_PORT

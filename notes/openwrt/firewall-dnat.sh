
WAN_IF=eth0.2
LAN_IF=br-lan

function forward6() {
    PROTO=$1
    ROUTER_PORT=$2
    HOST_IP=$3
    HOST_PORT=$4

    ip6tables -t nat -A PREROUTING -i $WAN_IF -p $PROTO --dport $ROUTER_PORT -j DNAT --to [$HOST_IP]:$HOST_PORT
    ip6tables -t filter -A forwarding_wan_rule -o $LAN_IF -d $HOST_IP -p $PROTO --dport $HOST_PORT -j ACCEPT
}

forward6 tcp 6010 fd00:7870:12::10 6010
forward6 udp 6010 fd00:7870:12::10 6010

forward6 tcp 6021 fd00:7870:12::21 6021
forward6 udp 6021 fd00:7870:12::21 6021

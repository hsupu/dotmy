#!/usr/bin/env bash

LPORT=5000
RPORT=5000

# sudo iptables -t nat -A PREROUTING \
#     -d 127.0.0.1 -p tcp --dport $LPORT \
#     -j DNAT --to-destination "$(hostip):$RPORT"

socat TCP4-LISTEN:$LPORT,fork,reuseaddr,bind=127.0.0.1 TCP4:$(hostip):$RPORT

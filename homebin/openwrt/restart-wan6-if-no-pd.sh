#!/usr/bin/env sh

NETIF=wan6

#DUMP="$(ubus call network.interface dump | jq ".interface | .[] | select(.interface == \"$NETIF\")")"
#echo $DUMP

PD="$(ubus call network.interface dump \
    | jq ".interface | .[] | select(.interface == \"$NETIF\") | .\"ipv6-prefix\" | .[0] | .preferred | if type == \"number\" then tonumber else 0 end " \
)"
#echo $PD
echo "IPv6-PD: Preferred=$PD"

if [[ $PD -gt 300 ]]; then
    exit 0
fi

echo "restart"
/sbin/ifup $NETIF

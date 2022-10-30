#!/usr/bin/env ash

COUNT=$(wc -l /tmp/echo | awk '{ print $1 }')
#echo $COUNT

if [[ $COUNT -gt 1000 ]]; then
    rm /tmp/echo
fi

date +"%Y/%m/%d %H:%M:%S" >> /tmp/echo

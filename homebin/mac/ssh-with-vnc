#!/usr/bin/env bash

if [[ $# < 3 ]]; then
    echo "run with [destination, local_port, display_number]"
    exit 1
fi

DST=$1
LOCAL_PORT=$2
REMOTE_DISPLAY=$3
REMOTE_PORT=$((5900+$REMOTE_DISPLAY))

LOCAL_IN=127.0.0.1:$LOCAL_PORT
REMOTE_OUT=127.0.0.1:$REMOTE_PORT

ssh -g \
    -L $LOCAL_IN:$REMOTE_OUT \
    $DST


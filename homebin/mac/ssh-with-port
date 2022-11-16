#!/usr/bin/env bash

if [[ $# < 2 ]]; then
    echo "run with [destination, remote_port, local_port]"
    exit 1
fi

DST=$1
REMOTE_PORT=$2

if [[ $# < 3 ]]; then
    LOCAL_PORT=$REMOTE_PORT
else
    LOCAL_PORT=$3
fi

LOCAL_IN=127.0.0.1:$LOCAL_PORT
REMOTE_OUT=127.0.0.1:$REMOTE_PORT

ssh -g \
    -L $LOCAL_IN:$REMOTE_OUT \
    $DST


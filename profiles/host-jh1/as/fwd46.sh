#!/usr/bin/env bash

PROTO=$1
SRC=$2
DST=$3

socat ${PROTO}-LISTEN:${SRC},fork,reuseaddr ${PROTO}6:${DST}

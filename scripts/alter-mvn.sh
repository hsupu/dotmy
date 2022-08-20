#!/usr/bin/env bash

if [[ $# < 1 ]]; then
    echo "Usage: [path-to-maven-root]"
    exit 1
fi

SHOME="$1"
SBIN="$SHOME/bin"
DBIN="/usr/bin"

sudo update-alternatives \
    --install "$DBIN/mvn"      "mvn"      "$SBIN/mvn" 50 \
    --slave   "$DBIN/mvnDebug" "mvnDebug" "$SBIN/mvnDebug"


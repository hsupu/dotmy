#!/usr/bin/env bash

if [[ $# < 1 ]]; then
    echo "Usage: [path-to-pwsh-root]"
    exit 1
fi

SHOME="$1"
SBIN="$SHOME"
DBIN="/usr/bin"

sudo update-alternatives \
    --install "$DBIN/pwsh" "pwsh" "$SBIN/pwsh" 50


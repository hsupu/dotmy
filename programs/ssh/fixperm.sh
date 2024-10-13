#!/usr/bin/env bash

SHDIR=$(cd "$(dirname "$0")"; pwd)
pushd "$SHDIR"

function fix_file() {
    if [[ -f "$1" ]]; then
        chmod 0600 "$1"
    else
        return 1
    fi
}

function fix_dir() {
    if [[ -d "$1" ]]; then
        pushd "$1" || return 1
        chmod 0700 .
        find . -type f -exec bash -c 'fix_file "$0"' {} \;
        popd
    else
        return 1
    fi
}

export -f fix_file
export -f fix_dir

fix_file config
fix_dir config.d/

popd


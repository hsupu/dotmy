#!/usr/bin/env bash

# V1

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
DOT_DIR=${SCRIPT_DIR}/dotfiles

pushd "${DOT_DIR}"
find . -type d -exec mkdir -p "${HOME}/{}" \;
find . -type f -exec ln -sf "${PWD}/{}" "${HOME}/{}" \;
popd

# V2

function remap_to_home() {
    SFILE="$1"
    if [[ $# < 2 ]]; then
        DFILE="$SFILE"
    else
        DFILE="$2"
    fi
    ln -sf "$MY_LOCAL_ROOT/raw/$SFILE" "$HOME/$DFILE"
}

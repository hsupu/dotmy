#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
pushd $SCRIPT_DIR

if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
    TARGET=$(/mnt/c/Windows/System32/HOSTNAME.exe | tr -d '[:cntrl:]')-wsl
    echo "WSL way: \"$TARGET\""
else
    # -s : short
    TARGET=$(hostname)
    echo "Linux/Mac way: \"$TARGET\""
fi

# -T --no-target-directory: always treat LINK as final file
ln -sTf $TARGET current
ln -sTf $PWD/$TARGET $HOME/.config/shell

popd

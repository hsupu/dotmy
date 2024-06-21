#!/usr/bin/env bash

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export DOTMY=$curdir

pushd $curdir || exit 1

if !(which python >/dev/null); then
    SDIR="/usr/bin"
    DDIR="/usr/bin"
    PRIOR=0
    sudo update-alternatives --install $DDIR/python python $SDIR/python3 $PRIOR
fi

./profiles/set-current.sh || exit 1

if [[ ! -d ./private ]]; then
    git clone --single-branch --branch main https://gitee.com/hsupu/dotmy-profiles.git private

    ./private/set-current.sh || exit 1
fi

python ./remap.py --map-file ./mapping.py
sudo python ./remap.py --map-file ./mapping.py

OS=$(uname -s)
case $OS in
    (Linux)
        if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
            python ./remap.py --map-file ./overrides/wsl/mapping.py
            sudo python ./remap.py --map-file ./overrides/wsl/mapping.py
        else
            python ./remap.py --map-file ./overrides/linux/mapping.py
        fi
        ;;
    (Darwin)
        python ./remap.py --map-file ./overrides/mac/mapping.py
        ;;
    (*)
        echo "Unknown \$(uname -s): $OS"
        exit 1
        ;;
esac

./shells/bash/install.sh

popd

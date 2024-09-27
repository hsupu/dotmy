#!/usr/bin/env bash

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export DOTMY=$curdir

pushd $curdir || exit 1

# check support os
OS=$(uname -s)
case $OS in
    (Linux)
    (Darwin)
        ;;
    (*)
        echo "Unknown \$(uname -s): $OS"
        exit 1
        ;;
esac

if !(which python >/dev/null); then
    SDIR="/usr/bin"
    DDIR="/usr/bin"
    PRIOR=0
    sudo update-alternatives --install $DDIR/python python $SDIR/python3 $PRIOR
    exitcode=$?
    if [[ $exitcode != 0 ]]; then
        echo "python not found and Failed to update-alternatives"
        exit $exitcode
    fi
fi

./profiles/set-current.sh || exit 1

if [[ ! -d ./private ]]; then
    git clone --single-branch --branch main https://gitee.com/hsupu/dotmy-profiles.git private

    ./private/set-current.sh || exit 1
fi

if [[ "$(python --version)" =~ ^"Python 3"\.(7|8)\. ]]; then
    remap_py="./remap.py37" # downgrade mainly for type hinting
else
    remap_py="./remap.py"
fi

if [[ -e ./profiles/current/mapping.py ]]; then
    mapfile=./profiles/current/mapping.py
else
    OS=$(uname -s)
    case $OS in
        (Linux)
            if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
                mapfile=./overrides/wsl/mapping.py
            else
                mapfile=./overrides/linux/mapping.py
            fi
            ;;
        (Darwin)
            mapfile=./overrides/mac/mapping.py
            ;;
    esac
fi

python $remap_py --map-file $MAP_FILE
sudo python $remap_py --map-file $MAP_FILE

if !(which zsh >/dev/null); then
    ./shells/zsh/install.sh
else
    ./shells/bash/install.sh
fi

popd

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

if [[ "$(python --version)" =~ ^"Python 3.8." ]]; then
    remap_py="./remap.py38"
else
    remap_py="./remap.py"
fi

if [[ -e ./profiles/current/mapping.py ]]; then
    python $remap_py
    sudo python $remap_py
else
    OS=$(uname -s)
    case $OS in
        (Linux)
            if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
                python $remap_py --map-file ./overrides/wsl/mapping.py
                sudo python $remap_py --map-file ./overrides/wsl/mapping.py
            else
                python $remap_py --map-file ./overrides/linux/mapping.py
                sudo python $remap_py --map-file ./overrides/linux/mapping.py
            fi
            ;;
        (Darwin)
            python $remap_py --map-file ./overrides/mac/mapping.py
            sudo python $remap_py --map-file ./overrides/mac/mapping.py
            ;;
        (*)
            echo "Unknown \$(uname -s): $OS"
            exit 1
            ;;
    esac
fi

./shells/bash/install.sh

popd

#!/usr/bin/env bash

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export DOTMY=$curdir

pushd $curdir || exit 1

# check support os
OS=$(uname -s)
case $OS in
    (Linux) ;;
    (Darwin) ;;
    (*)
        echo "Unknown \$(uname -s): $OS"
        exit 1
        ;;
esac

PYTHON=python
if !(which $PYTHON >/dev/null); then
    if !(which python3 >/dev/null); then
        echo "python3 not installed"
        exit 1
    fi

    if (which update-alternatives >/dev/null); then
        SDIR="/usr/bin"
        DDIR="/usr/bin"
        PRIOR=0
        sudo update-alternatives --install $DDIR/python $PYTHON $SDIR/python3 $PRIOR
        exitcode=$?
        if [[ $exitcode != 0 ]]; then
            echo "python not found and Failed to update-alternatives"
            exit $exitcode
        fi
    else
        PYTHON=python3
    fi
fi

./profiles/set-current.sh || exit 1

if [[ ! -d ./private ]]; then
    git clone --single-branch --branch main https://gitee.com/hsupu/dotmy-profiles.git private

    ./private/set-current.sh || exit 1
fi

# downgrade mainly for type hinting
# 3.7 不支持 | 的写法
# 3.9 不支持 T|None 的写法
if [[ "$($PYTHON --version)" =~ ^"Python 3"\.(7|8|9)\. ]]; then
    remap_py="./remap.py37"
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
                mapfile=./profiles/base/wsl/mapping.py
            else
                mapfile=./profiles/base/linux/mapping.py
            fi
            ;;
        (Darwin)
            mapfile=./profiles/base/mac/mapping.py
            ;;
    esac
fi

echo "remap"
$PYTHON $remap_py --map-file $mapfile
exitcode=$?
if [[ $exitcode != 0 ]]; then
    echo "Failed to remap"
    exit $exitcode
fi

echo "sudo remap"
sudo $PYTHON $remap_py --map-file $mapfile
exitcode=$?
if [[ $exitcode != 0 ]]; then
    echo "Failed to sudo remap"
    exit $exitcode
fi

if (which zsh >/dev/null); then
    export ZDOTDIR="$HOME/.config/zsh"
    mkdir -p $ZDOTDIR
    ./shells/zsh/install.sh
else
    ./shells/bash/install.sh
fi

popd

true

#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
pushd $SCRIPT_DIR

if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
    TARGET=$(/mnt/c/Windows/System32/HOSTNAME.exe | tr -d '[:cntrl:]' | tr '[:upper:]' '[:lower:]')-wsl
    echo "WSL way: \"$TARGET\""
else
    # -s : short
    TARGET=$(hostname | tr '[:upper:]' '[:lower:]')
    echo "Linux/Mac way: \"$TARGET\""
fi

# remove suffix if exists
TARGET=${TARGET%".lan"}
TARGET=${TARGET%"-wsl"}
# remove prefix if exists
TARGET=${TARGET#"wsl-"}

OS=$(uname -s)
case $OS in
    (Linux)
        if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
            TARGET="wsl-${TARGET}"
        fi
        # -s : symlink
        # -T --no-target-directory : always treat LINK as final file
        # -f : force, unlink if already exists
        ln -sTf "$TARGET" current
        ln -sTf "$PWD/$TARGET" $HOME/.config/shell
        ;;
    (MINGW64_NT-*)
        ln -sTf "$TARGET" current
        ln -sTf "$PWD/$TARGET" $HOME/.config/shell
        ;;
    (Darwin)
        # -s : symlink
        # -h : do NOT follow symlink
        # -f : force, unlink if already exists
        ln -shf "$TARGET" current
        ln -shf "$PWD/$TARGET" $HOME/.config/shell
        ;;
    (*)
        echo "Unknown \$(uname -s): $OS"
        exit 1
        ;;
esac

popd

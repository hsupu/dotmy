
if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
fi

source_or_warn "$curdir/aliases.sh"

OS=$(uname -s)
case $OS in
    (Linux)
        if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
            source_or_warn "$curdir/wsl/post.sh"
        else
            source_or_warn "$curdir/linux/post.sh"
        fi
        ;;
    (MINGW64_NT-*)
        source_or_warn "$curdir/msys2/post.sh"
        ;;
    (Darwin)
        source_or_warn "$curdir/mac/post.sh"
        ;;
esac

true

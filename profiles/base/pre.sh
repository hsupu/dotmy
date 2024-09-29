
if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
fi

# source_or_warn "$curdir/config.sh"

[[ -d "$HOME/bin" ]] || mkdir "$HOME/bin"
[[ -d "$HOME/.config" ]] || mkdir "$HOME/.config"
[[ -d "$HOME/.local" ]] || mkdir "$HOME/.local"
[[ -d "$HOME/.local/bin" ]] || mkdir "$HOME/.local/bin"

OS=$(uname -s)
case $OS in
    (Linux)
        if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
            source_or_warn "$curdir/wsl/pre.sh"
        else
            source_or_warn "$curdir/linux/pre.sh"
        fi
        ;;
    (MINGW64_NT-*)
        source_or_warn "$curdir/msys2/pre.sh"
        ;;
    (Darwin)
        source_or_warn "$curdir/mac/pre.sh"
        ;;
esac

true

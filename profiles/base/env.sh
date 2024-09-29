
if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
fi

OS=$(uname -s)
case $OS in
    (Linux)
        if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
            export IS_WSL=1
        fi
        IS_LINUX=1
        ;;
    (MINGW64_NT-*)
        IS_MSYS2=1
        ;;
    (Darwin)
        IS_MACOS=1
        ;;
    (*)
        echo "Unknown OS: $(uname -a)"
        exit 1
        ;;
esac

PATH_0="$HOME/bin:$HOME/.local/bin:$HOME/.local/bin.posix"
PATH_1=
PATH_2="/usr/local/sbin:/usr/local/bin"
PATH_3="/usr/bin:/bin:/usr/sbin:/sbin"
PATH_4=

PATH_opt0=
PATH_opt1=
PATH_opt2=
PATH_opt3="/snap/bin"
PATH_opt4="/usr/local/games:/usr/games"

OS=$(uname -s)
case $OS in
    (Linux)
        if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
            PATH_0+=":$HOME/.local/bin.wsl"
            PATH_4+=":/usr/lib/wsl/lib"
        fi
        PATH_0+=":$HOME/.local/bin.linux"
        ;;
    (Darwin)
        PATH_0+=":$HOME/.local/bin.mac"
        ;;
esac

MANPATH_0=
MANPATH_1="/usr/local/share/man:/usr/share/man"

[[ -z $EDITOR ]] && EDITOR="vim"
if which $EDITOR >/dev/null; then
    export EDITOR
    export VISUAL="$EDITOR"
fi

[[ -z $PAGER ]] && PAGER="less"
if which $PAGER >/dev/null; then
    export PAGER
fi

if [[ -z $LANG ]]; then
    # -u for user
    # -U for suffix ".UTF-8"
    # export LANG=$(locale -uU)
    export LANG="en_US.UTF-8"
fi
[[ -z $LANG ]] && export LC_ALL=$LANG

source_or_skip "$HOME/.config/shell/env.sh"
source_or_warn "$curdir/gen-path.sh"

true

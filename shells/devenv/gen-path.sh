
export PATH_OLD="$PATH"

function path_push_back() {
    if [[ $# < 2 ]]; then
        >&2 echo "path_push_back: invalid args"
        exit 1
    fi

    varname=$1
    # echo "varname $varname"

    if [[ $ZSH_VERSION ]]; then
        new="${(P)$(echo $varname)}"
    elif [[ $BASH_VERSION ]]; then
        new="${!varname}"
    else
        new=$(eval "echo \"\$$varname\"")
    fi
    # echo "$varname existing: $new"

    # https://zsh.sourceforge.io/Doc/Release/Options.html
    if [[ $ZSH_VERSION ]]; then
        setopt sh_word_split
        IFS=$':'; arrIN=($2); unset IFS;
        unsetopt sh_word_split
    else
        IFS=$':'; arrIN=($2); unset IFS;
    fi

    if [[ $# > 2 && $3 == '-q' ]]; then
        WARN=1
    else
        WARN=
    fi

    for i in "${arrIN[@]}"; do
        if [[ -z $i ]]; then
            continue
        fi

        if [[ ! -d "$i" ]]; then
            if [[ -s $WARN ]]; then
                >&2 echo "path_push_back: $varname: dir not found: $i"
            fi
            continue
        fi
        # echo "$varname found: $i"

        if [[ -z $new ]]; then
            new="$i"
        else
            new="$new:$i"
        fi
    done
    # echo "$varname updated: $new"

    # declare "$varname"="$new"
    export "$varname"="$new"
    unset varname WARN new arrIN i
}

PATH_next=""
path_push_back PATH_next "${PATH_0}"
path_push_back PATH_next "$HOME/bin:$HOME/.local/bin:$HOME/.local/bin.posix"

OS=$(uname -s)
case $OS in
    (Linux)
        if [[ -e "/proc/sys/fs/binfmt_misc/WSLInterop" ]]; then
            path_push_back PATH_next "$HOME/.local/bin.linux:$HOME/.local/bin.wsl" -q
        else
            path_push_back PATH_next "$HOME/.local/bin.linux" -q
        fi
        ;;
    (Darwin)
        path_push_back PATH_next "$HOME/.local/bin.mac" -q
        ;;
    (*)
        echo "Unknown \$(uname -s): $OS"
        exit 1
        ;;
esac

path_push_back PATH_next "${PATH_1}"
path_push_back PATH_next "/usr/local/sbin:/usr/local/bin" -q
path_push_back PATH_next "${PATH_2}"
path_push_back PATH_next "/usr/bin:/bin:/usr/sbin:/sbin" -q
path_push_back PATH_next "${PATH_3}:${PATH_4}"
PATH="${PATH_next}"
unset PATH_next
export PATH

MANPATH_next=""
path_push_back MANPATH_next "${MANPATH_0}"
path_push_back MANPATH_next "/usr/local/share/man:/usr/share/man"
path_push_back MANPATH_next "${MANPATH_1}"
MANPATH="${MANPATH_next}"
unset MANPATH_next
export MANPATH

# [xp] we may use it later
# unset path_push_back

true


export PATH_OLD="$PATH"

function path_push_back() {
    if [[ $# < 2 ]]; then
        >&2 echo "path_push_back: invalid args"
        exit(1)
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

PATH=""
path_push_back PATH "${PATH_0}"
path_push_back PATH "$HOME/bin:$HOME/.local/bin:$HOME/.local/bin.linux:$HOME/.local/bin.wsl:$HOME/.local/bin.mac" -q
path_push_back PATH "${PATH_1}"
path_push_back PATH "/usr/local/sbin:/usr/local/bin" -q
path_push_back PATH "${PATH_2}"
path_push_back PATH "/usr/sbin:/usr/bin" -q
path_push_back PATH "${PATH_3}"
path_push_back PATH "/sbin:/bin" -q
path_push_back PATH "${PATH_4}"
export PATH

MANPATH=""
path_push_back MANPATH "${MANPATH_0}"
path_push_back MANPATH "/usr/local/share/man:/usr/share/man"
path_push_back MANPATH "${MANPATH_1}"
export MANPATH

# [xp] we may use it later
# unset path_push_back

true

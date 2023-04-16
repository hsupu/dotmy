
export PATH_OLD="$PATH"

function path_push_back() {
    if [[ $# < 2 ]]; then
        >&2 echo "path_push_back: invalid args"
        exit(1)
    fi

    varname=$1
    # echo "varname $varname"

    if [[ $ZSH_VERSION ]]; then
        existing="${(P)$(echo $varname)}"
    elif [[ $BASH_VERSION ]]; then
        existing="${!varname}"
    else
        existing=$(eval "echo \"\$$varname\"")
    fi
    # echo "$varname existing: $existing"

    # https://zsh.sourceforge.io/Doc/Release/Options.html
    if [[ $ZSH_VERSION ]]; then
        setopt sh_word_split
        IFS=$':'; arrIN=($2); unset IFS;
        unsetopt sh_word_split
    else
        IFS=$':'; arrIN=($2); unset IFS;
    fi

    for i in "${arrIN[@]}"; do
        if [[ -z $i ]]; then
            continue
        fi

        if [[ ! -d "$i" ]]; then
            >&2 echo "path_push_back: $varname: dir not found: $i"
            continue
        fi
        # echo "$varname found: $i"

        if [[ -z $existing ]]; then
            existing="$i"
        else
            existing="$existing:$i"
        fi
    done
    # echo "$varname updated: $existing"

    # declare "$varname"="$existing"
    export "$varname"="$existing"
    unset i arrIN varname existing
}

PATH=""
path_push_back PATH "${PATH_0}"
path_push_back PATH "$HOME/bin:$HOME/.local/bin"
path_push_back PATH "${PATH_1}"
path_push_back PATH "/usr/local/sbin:/usr/local/bin"
path_push_back PATH "${PATH_2}"
path_push_back PATH "/usr/sbin:/usr/bin"
path_push_back PATH "${PATH_3}"
path_push_back PATH "/sbin:/bin"
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

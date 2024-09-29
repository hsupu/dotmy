
function path_push_back() {
    # <varname> <pathes> <flags...>
    if [[ $# < 2 ]]; then
        >&2 echo "path_push_back: invalid args"
        exit 1
    fi

    varname=$1; shift

    # https://zsh.sourceforge.io/Doc/Release/Options.html
    if [[ $ZSH_VERSION ]]; then
        setopt sh_word_split
        IFS=$':'; arrIN=($1); unset IFS; shift
        unsetopt sh_word_split
    else
        IFS=$':'; arrIN=($1); unset IFS; shift
    fi

    # check if empty
    if [[ ${#arrIN[@]} == 0 ]]; then
        return
    fi

    # flags
    FORCE=0
    WARN=0
    if [[ $# > 0 ]]; then
        # echo $@
        for i in "$@"; do
            arg=$(echo $i | tr '[:upper:]' '[:lower:]')
            # echo "\$arg=$arg"
            if [[ $arg == '-f' || $arg == '--force' ]]; then
                FORCE=1
                continue
            fi
            if [[ $arg == '-q' || $arg == '--quiet' ]]; then
                WARN=1
                continue
            fi
        done
        unset arg i
    fi

    # apply
    if [[ $ZSH_VERSION ]]; then
        new="${(P)$(echo $varname)}"
    elif [[ $BASH_VERSION ]]; then
        new="${!varname}"
    else
        new=$(eval "echo \"\$$varname\"")
    fi
    # echo "$varname: \"$new\" + @($arrIN)"
    # echo "\$FORCE=$FORCE"
    # echo "\$WARN=$WARN"

    for i in "${arrIN[@]}"; do
        if [[ -z $i ]]; then
            continue
        fi

        if [[ ! -d "$i" ]]; then
            if [[ $FORCE > 0 ]]; then
                echo "path_push_back: $varname: force add non-found dir: $i"
            else
                if [[ $WARN > 0 ]]; then
                    >&2 echo "path_push_back: $varname: dir not found: $i"
                fi
                continue
            fi
        else
            # echo "$varname found: $i"
        fi

        if [[ -z $new ]]; then
            new="$i"
        else
            new+=":$i"
        fi
    done
    # echo "$varname updated: $new"

    # declare "$varname"="$new"
    export "$varname"="$new"
    unset varname WARN new arrIN i
}

PATH_next=""
path_push_back PATH_next "${PATH_0}" -f
path_push_back PATH_next "${PATH_opt0}"
path_push_back PATH_next "${PATH_1}" -f
path_push_back PATH_next "${PATH_opt1}"
path_push_back PATH_next "${PATH_2}" -f
path_push_back PATH_next "${PATH_opt2}"
path_push_back PATH_next "${PATH_3}" -f
path_push_back PATH_next "${PATH_opt3}"
path_push_back PATH_next "${PATH_4}" -f
path_push_back PATH_next "${PATH_opt4}"
export PATH_OLD="$PATH"
export PATH="${PATH_next}"
unset PATH_next

MANPATH_next=""
path_push_back MANPATH_next "${MANPATH_0}"
path_push_back MANPATH_next "${MANPATH_1}"
export MANPATH_OLD="$MANPATH"
export MANPATH="${MANPATH_next}"
unset MANPATH_next

# [xp] maybe use it later, so don't unset it now
# unset path_push_back

true


export PATH_OLD="$PATH"

function path_push_back() {
    # https://zsh.sourceforge.io/Doc/Release/Options.html
    if [[ $ZSH_VERSION ]]; then
        setopt sh_word_split
    fi
    IFS=$':'; arrIN=($1); unset IFS;
    if [[ $ZSH_VERSION ]]; then
        unsetopt sh_word_split
    fi

    for i in "${arrIN[@]}"; do
        if [[ -z $i ]]; then
            continue
        fi

        if [[ ! -d "$i" ]]; then
            echo "PATH not found: $i" >&2
            continue
        fi
        # echo "PATH found: $i"

        if [[ -z $PATH ]]; then
            PATH="$1"
        else
            PATH="$PATH:$i"
        fi
    done
    unset i arrIN
    export PATH
}

export PATH=""
path_push_back "${PATH_0}"
path_push_back "$HOME/bin:$HOME/.local/bin"
path_push_back "${PATH_1}"
path_push_back "/usr/local/sbin:/usr/local/bin"
path_push_back "${PATH_2}"
path_push_back "/usr/sbin:/usr/bin"
path_push_back "${PATH_3}"
path_push_back "/sbin:/bin"
path_push_back "${PATH_4}"

unset path_push_back

true

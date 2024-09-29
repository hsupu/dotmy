
function source_or_warn() {
    if [[ -e $1 ]]; then
        . "$1" || echo "source failed: $1"
    else
        echo "source not found: $1"
    fi
}

function source_or_skip() {
    if [[ -e $1 ]]; then
        . "$1" || echo "source failed: $1"
    fi
}

alias safe_source=source_or_warn

# https://unix.stackexchange.com/questions/4650/determining-path-to-sourced-shell-script
# ${BASH_SOURCE[0]:-${(%):-%x}}

# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Modifiers
# :A for 1) absolute path 2) resolve symlink
# ${0:A}

# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
export SHRC_DIR="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
export DOTMY="$(cd "${SHRC_DIR}/../.."; pwd)"

# source "$HOME/.config/shell/env.sh" and gen $PATH inside
source_or_warn "$DOTMY/profiles/base/env.sh"

if [[ ! -d $ZSH ]]; then
    [[ -n $ZSH ]] && echo "\$ZSH invalid: $ZSH"

    [[ -d $ZSH ]] || ZSH="$HOME/.local/oh-my-zsh"
    # [[ -d $ZSH ]] || ZSH="$HOME/.local/omz"
    [[ -d $ZSH ]] || ZSH="$HOME/.config/oh-my-zsh"
    # [[ -d $ZSH ]] || ZSH="$HOME/.config/omz"
    [[ -d $ZSH ]] || ZSH="$HOME/.oh-my-zsh"

    [[ -d $ZSH ]] && export ZSH || echo "\$ZSH not found"
fi
[[ -z $ZSH_CUSTOM ]] && export ZSH_CUSTOM="$ZSH/custom"
[[ -z $ZSH_CACHE_DIR ]] && export ZSH_CACHE_DIR="$ZSH/cache"

true

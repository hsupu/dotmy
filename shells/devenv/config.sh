
# 功能性
#

# 使 less 命令对非文本文件更友好, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# 色彩
#

if [[ -x /usr/bin/dircolors ]]; then
    [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Shell-specific
#

if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
  source_or_skip "$curdir/config.bash.sh"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
  source_or_skip "$curdir/config.zsh.sh"
fi

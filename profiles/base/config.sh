
# Shell-specific
#

if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
  source_or_skip "$curdir/config.bash.sh"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
  source_or_skip "$curdir/config.zsh.sh"
fi


if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
fi

source_or_skip "$curdir/funcs.sh"
source_or_skip "$curdir/prompt.sh"

true


if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
fi

if [[ $(uname) == "Darwin" ]]; then
  source_or_warn "$curdir/mac/env.sh"
fi
source_or_warn "$curdir/env.sh"
source_or_warn "$curdir/config.sh"

true

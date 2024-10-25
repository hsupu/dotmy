
if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(readlink -f -- ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(readlink -f -- ${(%):-%x})")"; pwd)"
fi

true

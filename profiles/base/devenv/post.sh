
if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
fi

source_or_warn "$curdir/funcs.sh"

if [[ -e $(which ssh-agent 2>/dev/null) ]]; then
  # copy from https://gist.github.com/JanTvrdik/33df5554d981973fce02
  export SSH_AUTH_SOCK="/tmp/ssh-auth.socket"
  # 0 for ok, 1 for empty, 2 for disconnected
  ssh-add -l >/dev/null 2>&1
  if [[ $? = 2 ]]; then
    echo "Setting up ssh-agent"
    rm -f $SSH_AUTH_SOCK
    eval $(ssh-agent -s -a $SSH_AUTH_SOCK) >/dev/null
  fi

  # copy from https://www.scivision.dev/ssh-agent-windows-linux/
  # if [[ -e $(which pgrep 2>/dev/null) ]]; then
  #   pid=$(pgrep ssh-agent)
  # fi
  # if [[ -z $pid ]]; then
  #   # cleanup and start new one
  #   rm -rf /tmp/ssh-*
  #   eval $(ssh-agent -s) >/dev/null
  # else
  #   # use existing one
  #   export SSH_AGENT_PID=$pid
  #   export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.\*)
  # fi
fi

true

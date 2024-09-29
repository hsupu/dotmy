
agm2() {
  local MINGW_DIRS="mingw32 mingw64"
  local AG_FIND=

  for dir in ${MINGW_DIRS}; do
    if type -p /${dir}/bin/ag >/dev/null; then
      AG_FIND=/${dir}/bin/ag
    fi
  done

  if ! type -p /usr/bin/git >/dev/null; then
    echo "bash: git: command not found. Please install \"git\" package."
    exit 1
  fi

  if [ -n "$AG_FIND" ]; then
    $AG_FIND --makepkg --depth 1 "$@" $(git rev-parse --show-toplevel)
  else
    echo "bash: ag: conmmand not found. Please install \"mingw-w64-i686-ag\" or \"mingw-w64-x86_64-ag\" package."
    exit 1
  fi
}

true

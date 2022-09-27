
source_or_warn "$DOTMY/shells/devenv/pre.sh"
source_or_warn "$DOTMY/shells/devenv/mac/env.sh"

if [[ -d $PYENV_ROOT ]]; then
    [[ -d "${PYENV_ROOT}/bin" ]] || ln -s $(brew --prefix pyenv)/bin "${PYENV_ROOT}/"
fi

PATH_2="${PATH_2}:/usr/local/opt/curl/bin"
PATH_2="${PATH_2}:/usr/local/opt/openssl@1.1/bin"
PATH_2="${PATH_2}:/usr/local/opt/sqlite/bin"

source_or_warn "$DOTMY/shells/devenv/gen-path.sh"

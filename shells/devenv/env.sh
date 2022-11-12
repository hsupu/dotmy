
[[ -d "$HOME/bin" ]] || mkdir "$HOME/bin"
[[ -d "$HOME/.config" ]] || mkdir "$HOME/.config"
[[ -d "$HOME/.local" ]] || mkdir "$HOME/.local"

function path_1_push_back() {
    if [[ -e $(which cygpath 2>/dev/null) ]]; then
        new=$(cygpath $1)
    else
        new="$1"
    fi
    PATH_1="${PATH_1}:$new"
    unset new
}

[[ -z $EDITOR ]] && EDITOR="vim"
[[ -z $PAGER ]] && PAGER="less"

# dotnet
[[ -d $HOME/.dotnet/tools ]] && path_1_push_back "$HOME/.dotnet/tools"

# golang
[[ -z $GOROOT ]] && GOROOT="/usr/local/opt/go"
[[ -z $GOPATH ]] && GOPATH="$HOME/.golang"
[[ -d $GOROOT ]] && export GOROOT && path_1_push_back "$GOROOT/bin"
[[ -d $GOPATH ]] && export GOPATH && path_1_push_back "$GOPATH/bin"
export GO111MODULE=on
export GOPROXY=https://goproxy.cn

# java
[[ -z $JAVA_HOME ]] && JAVA_HOME="/usr/local/opt/java"
[[ -d $JAVA_HOME ]] && export JAVA_HOME \
    && export CLASSPATH=".:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar" \
    && path_1_push_back "${JAVA_HOME}/bin"

# js
[[ -z $NVM_DIR ]] && NVM_DIR="$HOME/.local/nvm"
[[ -z $PNPM_HOME ]] && PNPM_HOME="$HOME/.local/share/pnpm"
[[ -d $NVM_DIR ]] && export NVM_DIR
[[ -d $PNPM_HOME ]] && export PNPM_HOME
export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node/"

# python
[[ -z $PYENV_ROOT ]] && PYENV_ROOT="$HOME/.local/pyenv"
[[ -d $PYENV_ROOT ]] && export PYENV_ROOT && path_1_push_back "${PYENV_ROOT}/bin"

# php
[[ -z $COMPOSER_ROOT ]] && COMPOSER_ROOT="$HOME/.composer"
[[ -d $COMPOSER_ROOT ]] && export COMPOSER_ROOT && path_1_push_back "${COMPOSER_ROOT}/vendor/bin"

# ruby
[[ -z $RVM_DIR ]] && RVM_DIR="$HOME/.local/rvm"

# rust
[[ -z $CARGO_ROOT ]] && CARGO_ROOT="$HOME/.cargo"
[[ -d $CARGO_ROOT ]] && export CARGO_ROOT && path_1_push_back "${CARGO_ROOT}/bin"

unset path_1_push_back

if [[ -z $LANG ]]; then
    # -u for user
    # -U for suffix ".UTF-8"
    # export LANG=$(locale -uU)
    export LANG=en_US.UTF-8
fi
[[ -z $LANG ]] && export LC_ALL=$LANG

true


# case $(uname) in
#     "Linux")
#         ;;
#     "Darwin")
#         . "$DOTMY/shells/devenv/mac/env.sh"
#         ;;
#     *)
#         >&2 echo "Unknown OS: $(uname)"
#         return
#         ;;
# esac

# echo $PATH

[[ -d "$HOME/bin" ]] || mkdir "$HOME/bin"
[[ -d "$HOME/.config" ]] || mkdir "$HOME/.config"
[[ -d "$HOME/.local" ]] || mkdir "$HOME/.local"

function path_1_push_back() {
    if [[ -e "$(which cygpath 2>/dev/null)" ]]; then
        new=$(cygpath $1)
    else
        new="$1"
    fi
    PATH_1="${PATH_1}:$new"
    unset new
}

[[ -z $EDITOR ]] && EDITOR="vim"
if which $EDITOR >/dev/null; then
    export EDITOR
fi
[[ -z $PAGER ]] && PAGER="less"
if which $PAGER >/dev/null; then
    export PAGER
fi

# dotnet
# [[ -z $NUGET_PACKAGES ]] && NUGET_PACKAGES="$HOME/.local/nuget/packages"
if [[ -d "$HOME/.dotnet" ]]; then
    export DOTNET_ADD_GLOBAL_TOOLS_TO_PATH="false"
    export DOTNET_NOLOGO="true"
    export DOTNET_CLI_TELEMETRY_OPTOUT="false"
    export DOTNET_CLI_UI_LANGUAGE="en-US"
    path_1_push_back "$HOME/.dotnet/tools"
fi

# golang
[[ -z $GOROOT ]] && GOROOT="/usr/local/opt/go"
[[ -z $GOPATH ]] && GOPATH="$HOME/.golang"
if [[ -d $GOROOT ]]; then
    export GOROOT
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn
    path_1_push_back "$GOROOT/bin"
fi
if [[ -d $GOPATH ]]; then
    export GOPATH
    path_1_push_back "$GOPATH/bin"
fi

# java
[[ -z $JAVA_HOME ]] && JAVA_HOME="/usr/local/opt/java"
if [[ -d $JAVA_HOME ]]; then
    export JAVA_HOME
    export CLASSPATH=".:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar"
    path_1_push_back "${JAVA_HOME}/bin"
fi

# js
[[ -z $NVM_DIR ]] && NVM_DIR="$HOME/.local/nvm"
[[ -z $PNPM_HOME ]] && PNPM_HOME="$HOME/.local/share/pnpm"
if [[ -d $NVM_DIR ]]; then
    export NVM_DIR
    export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node/"
    # delay to enable_nvm
fi
if [[ -d $PNPM_HOME ]]; then
    export PNPM_HOME
    path_1_push_back "${PNPM_HOME}/bin"
fi

# python
[[ -z $PYENV_ROOT ]] && PYENV_ROOT="$HOME/.local/pyenv"
if [[ -d $PYENV_ROOT ]] ; then
    export PYENV_ROOT
    path_1_push_back "${PYENV_ROOT}/bin"
    # delay to enable_pyenv
fi

# php
# https://getcomposer.org/doc/03-cli.md#composer-home
[[ -z $COMPOSER_HOME ]] && COMPOSER_HOME="$HOME/.local/composer"
# [[ -z $COMPOSER_BIN ]] && COMPOSER_BIN="${COMPOSER_HOME}/vendor/bin"
if [[ -d $COMPOSER_HOME ]] ; then
    export COMPOSER_HOME
    path_1_push_back "${COMPOSER_HOME}/vendor/bin"
fi

# ruby
[[ -z $RBENV_DIR ]] && RBENV_DIR="$HOME/.local/rbenv"
[[ -z $RVM_DIR ]] && RVM_DIR="$HOME/.local/rvm"
if [[ -d $RBENV_DIR ]]; then
    export RBENV_DIR
    # delay to enable_rbenv
fi
if [[ -d $RVM_DIR ]]; then
    export RVM_DIR
    # delay to enable_rvm
fi

# ruby
[[ -z $RUBY_ROOT ]] && RUBY_ROOT="/usr/local/opt/ruby"
if [[ -d $RUBY_ROOT ]]; then
    export RUBY_ROOT
    path_1_push_back "${RUBY_ROOT}/bin"
    PATH="${RUBY_ROOT}/bin:$PATH"
    if which gem >/dev/null; then
        USER_GEM_HOME="$(gem environment user_gemhome)"
        if [[ -d $USER_GEM_HOME ]]; then
            path_1_push_back "${USER_GEM_HOME}/bin"
        fi
        GEM_HOME="$(gem environment home)"
        if [[ -d $GEM_HOME ]]; then
            path_1_push_back "${GEM_HOME}/bin"
        fi
    fi
fi

# rust
[[ -z $CARGO_ROOT ]] && CARGO_ROOT="$HOME/.local/cargo"
if [[ -d $CARGO_ROOT ]]; then
    export CARGO_ROOT
    path_1_push_back "${CARGO_ROOT}/bin"
fi

unset path_1_push_back

if [[ -z $LANG ]]; then
    # -u for user
    # -U for suffix ".UTF-8"
    # export LANG=$(locale -uU)
    export LANG="en_US.UTF-8"
fi
[[ -z $LANG ]] && export LC_ALL=$LANG

true

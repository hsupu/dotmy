
# enables
#

function enable_bit() {
    complete -C $(which bit) bit
}

# https://github.com/nvm-sh/nvm
function enable_nvm() {
    if [[ -z $NVM_DIR ]]; then
        echo "\$NVM_DIR not set"
        return
    fi
    safe_source "${NVM_DIR}/nvm.sh"
    safe_source "${NVM_DIR}/bash_completion"

    if [[ -n $PNPM_HOME ]]; then
        path_push_back "$PNPM_HOME"
    fi
}

function enable_pipx() {
    # eval "$(register-python-argcomplete pipx)"
    echo TODO
}

function enable_pyenv() {
    if [[ -z $PYENV_ROOT ]]; then
        echo "\$PYENV_ROOT not set"
        return
    fi
    eval "$(pyenv init --path)"
    # $PYENV_ROOT/shims
    eval "$(pyenv init -)"
    # $PYENV_ROOT/plugins/pyenv-virtualenv/shims
    # if which pyenv-virtualenv-init > /dev/null; then
    #     eval "$(pyenv virtualenv-init -)"
    # fi

    [[ ! -e "$HOME/.local/bin/pyenv" ]] && ln -s "${PYENV_ROOT}/bin/pyenv" "$HOME/.local/bin/"
}

function enable_rbenv() {
    # $RBENV_DIR/bin:$RBENV_DIR/shims
    eval "$(rbenv init -)"
}

function enable_rvm() {
    if [[ -z $RVM_DIR ]]; then
        echo "\$RVM_DIR not set"
        return
    fi
    safe_source "${RVM_DIR}/scripts/rvm"
}

# misc
#

function link_to_home_bin() {
    DIR="$1"
    SFILE="$2"
    if [[ $# < 3 ]]; then
        DFILE="$SFILE"
    else
        DFILE="$3"
    fi
    if [[ ! -s "$HOME/bin/$DFILE" ]]; then
        ln -s "$DIR/$SFILE" "$HOME/bin/$SFILE"
    fi
}

function tree() {
    # find ${1:-.} | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"
    ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//──/g' -e 's/─/├/' -e '$s/├/└/'
}

# for long running commands. e..g: sleep 10s; alert
# function alert() {
#     if [[ $? = 0 ]]; then
#         msg=terminal
#     else
#         msg=error
#     fi
#     # libnotify-bin
#     # trick to fetch from history: "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"
#     notify-send --urgency=low -i $msg $1
# }

function set_proxy() {
    if [[ $# < 1 ]]; then
        proxy=host:50000
    else
        proxy=$1
    fi

    export ALL_PROXY=socks5h://$proxy
    export HTTP_PROXY=$ALL_PROXY
    export HTTPS_PROXY=$ALL_PROXY
    export all_proxy=$proxy
    export http_proxy=$all_proxy
    export https_proxy=$all_proxy
}

function unset_proxy() {
    unset ALL_PROXY
    unset all_proxy
    unset HTTP_PROXY
    unset http_proxy
    unset HTTPS_PROXY
    unset https_proxy
}

function load_sshkeys() {
    ssh-add && echo "ssh-agent is set up with the following keys:" && ssh-add -l
}

true

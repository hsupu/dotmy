# bash only source one file under user's home directory, we should make them work
# the order is: .bash_profile .bash_login .profile
#
# see example in /usr/share/doc/bash-doc/examples (install package "bash-doc" first)


# the default umask is set in /etc/profile; for setting the umask for ssh logins, install and configure the "libpam-umask" package.
#umask 022


function source_or_warn() {
    if [[ -s "$1" ]]; then
        . "$1"
    else
        echo "source: not found: $1"
    fi
}

function source_or_skip() {
    [[ -s "$1" ]] && . "$1"
}

alias safe_source=source_or_warn

export SHRC_DIR="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export DOTMY="$(cd "${SHRC_DIR}/../.."; pwd)"


# source "$HOME/.config/shell/env.sh" and gen $PATH inside
source_or_warn "$DOTMY/profiles/base/env.sh"

source_or_skip "$HOME/.bash_login"
source_or_warn "$HOME/.bashrc"

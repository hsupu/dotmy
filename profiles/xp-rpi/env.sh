
export DOTMY="$HOME/.config/dotmy"
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="xp-rpi"

# pkg-config
PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/share/pkgconfig:/usr/lib/aarch64-linux-gnu/pkgconfig"
# cargo
CARGO_DIR="$HOME/.cargo"
# java
JAVA_HOME="/opt/current/jdk"
CLASSPATH=".:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar"
# pyenv: $PYENV_DIR/plugins/pyenv-virtualenv/shims:$PYENV_DIR/shims
PYENV_ROOT="$HOME/.pyenv"
# nvm
NVM_DIR="$HOME/.local/nvm"
# pnpm
PNPM_HOME="$HOME/.local/share/pnpm"
# rbenv
RBENV_DIR="$HOME/.rbenv"

source_or_warn "$DOTMY/profiles/base/devenv/env-defaults.sh"

true

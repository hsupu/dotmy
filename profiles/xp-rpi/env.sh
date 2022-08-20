
export DOTMY="$HOME/.config/dotmy"
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="xp-rpi"

# pkg-config
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/share/pkgconfig:/usr/lib/aarch64-linux-gnu/pkgconfig"
# cargo
export CARGO_DIR="$HOME/.cargo"
# java
export JAVA_HOME="/opt/current/jdk"
export CLASSPATH=".:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar"
# pyenv: $PYENV_DIR/plugins/pyenv-virtualenv/shims:$PYENV_DIR/shims
export PYENV_ROOT="$HOME/.pyenv"
# nvm
export NVM_DIR="$HOME/.local/nvm"
# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
# rbenv
export RBENV_DIR="$HOME/.rbenv"

PATH_4="/snap/bin"

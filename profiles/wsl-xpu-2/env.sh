
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="xpu-2"

# nvm
export NVM_DIR="$HOME/.local/nvm"
# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
# pyenv
export PYENV_ROOT="$HOME/.local/pyenv"

source_or_warn "$DOTMY/profiles/base/devenv/env-defaults.sh"

true

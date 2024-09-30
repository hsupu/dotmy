
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="puxu-2"

# nvm
NVM_DIR="$HOME/.local/nvm"
# pnpm
PNPM_HOME="$HOME/.local/share/pnpm"
# pyenv
PYENV_ROOT="$HOME/.local/pyenv"

source_or_warn "$DOTMY/profiles/base/devenv/env-defaults.sh"

true

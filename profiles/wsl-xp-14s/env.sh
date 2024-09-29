
export DOTMY="$HOME/.config/dotmy"
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="xp-14s"

# nvm
NVM_DIR="$HOME/.local/nvm"
# pnpm
PNPM_HOME="$HOME/.local/share/pnpm"
# pyenv
PYENV_ROOT="$HOME/.local/pyenv"

source_or_warn "$DOTMY/profiles/base/devenv/env-defaults.sh"

true

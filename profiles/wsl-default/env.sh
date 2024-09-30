
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="default"

source_or_warn "$DOTMY/profiles/base/devenv/env-defaults.sh"

true

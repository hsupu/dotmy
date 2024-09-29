
export DOTMY="$HOME/.config/dotmy"
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="msys2-xp-pc1"

# https://github.com/PKRoma/msys2-code/blob/master/winsup/doc/setup-locale.xml
export LANG=en_US.UTF-8

source_or_warn "$DOTMY/profiles/base/devenv/env-defaults.sh"

true


source_or_warn "$DOTMY/profiles/base/post.sh"
source_or_warn "$DOTMY/profiles/base/devenv/post.sh"
source_or_warn "$DOTMY/profiles/base/wsl/post.sh"

enable_pyenv
enable_rbenv

true

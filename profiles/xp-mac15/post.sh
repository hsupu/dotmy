
source_or_warn "$DOTMY/profiles/base/post.sh"
source_or_warn "$DOTMY/profiles/base/devenv/post.sh"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
source_or_warn "$HOME/.iterm2_shell_integration.zsh"

source_or_warn "$HOME/.local/acme.sh/acme.sh.env"

true

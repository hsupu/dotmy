
export DOTMY="$HOME/.config/dotmy"
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="xp-m3a"

eval "$(/opt/homebrew/bin/brew shellenv)"

PATH_1+=":$(brew --prefix)/bin:$(brew --prefix)/sbin"

PATH_opt2+=":$(brew --prefix curl)/bin"
PATH_opt2+=":$(brew --prefix openssl@1.1)/bin"
PATH_opt2+=":$(brew --prefix sqlite)/bin"

PATH_4+=":/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"

# golang
GOPATH="$HOME/.local/golang"
# java
JAVA_HOME="/Library/Java/Home"
# php
COMPOSER_HOME="$HOME/.local/composer"
# python
# pyenv data dir
PYENV_ROOT="$HOME/.local/pyenv"
# node
# nvm data dir - avoid losing installations when "brew upgrade nvm"
NVM_DIR="$HOME/.local/nvm"
# ruby
# rbenv data dir
RBENV_ROOT="$HOME/.local/rbenv"
# rust
CARGO_HOME="$HOME/.local/cargo"
RUSTUP_HOME="$HOME/.local/rustup"
# vim
# VIMRUNTIME="/usr/local/opt/vim/share/vim/vim90"
# VIMINIT="$HOME/.vim/vimrc"

# editor
EDITOR="vim"

source_or_warn "$DOTMY/profiles/base/devenv/env-defaults.sh"

true

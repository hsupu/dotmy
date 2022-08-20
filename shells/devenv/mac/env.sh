# locale
export LANG="en_US.UTF-8"

# editor
export EDITOR="vim"
export VISUAL="$EDITOR"

# brew
export HOMEBREW_GITHUB_API_TOKEN="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"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

export HOMEBREW_BREW_GIT_REMOTE=https://mirrors.ustc.edu.cn/brew.git
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export HOMEBREW_CORE_GIT_REMOTE=https://mirrors.ustc.edu.cn/homebrew-core.git

# java
[[ -z $JAVA_HOME ]] && export JAVA_HOME="/Library/Java/Home"

# man
export MANPATH="/usr/local/share/man:/usr/share/man"
[[ -d /Applications/Wireshark.app ]] && export MANPATH="$MANPATH:/Applications/Wireshark.app/Contents/Resources/share/man"

# ruby
if [[ -z $RUBY_ROOT ]]; then
    RUBY_ROOT="/usr/local/opt/ruby"
    GEM_DIR="/usr/local/lib/ruby/gems/3.1.0"
    [[ -d $RUBY_ROOT ]] && export PATH_1="${PATH_1}:${RUBY_ROOT}/bin"
    [[ -d $GEM_DIR ]] && export PATH_1="${PATH_1}:${GEM_DIR}/bin"
fi

# tex
# TEX_ROOT="/Library/TeX"
# PATH_2="${PATH_2}:${TEX_ROOT}/texbin"

true

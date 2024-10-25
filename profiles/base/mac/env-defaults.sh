
# brew
export HOMEBREW_BREW_GIT_REMOTE=https://mirrors.ustc.edu.cn/brew.git
export HOMEBREW_CORE_GIT_REMOTE=https://mirrors.ustc.edu.cn/homebrew-core.git
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

# iterm
if [[ -d "/Applications/iTerm.app" ]]; then
    PATH_opt4+=":/Applications/iTerm.app/Contents/Resources/utilities"
fi

# java
[[ -z $JAVA_HOME ]] && JAVA_HOME="/Library/Java/Home"

# python
if [[ -d $PYENV_ROOT ]]; then
    [[ -d "${PYENV_ROOT}/bin" ]] || ln -s "$(brew --prefix pyenv)/bin" "${PYENV_ROOT}/"
fi

# tex
# TEX_ROOT="/Library/TeX"
# PATH_2="${PATH_2}:${TEX_ROOT}/texbin"

# vmware
if [[ -d "/Applications/VMware Fusion.app" ]]; then
    PATH_opt4+=":/Applications/VMware Fusion.app/Contents/Public"
fi

# wireshark
if [[ -d "/Applications/Wireshark.app" ]]; then
    PATH_opt4+=":/Applications/Wireshark.app/Contents/MacOS"
    MANPATH_opt1=":/Applications/Wireshark.app/Contents/Resources/share/man"
fi

if [[ $(uname -m) == "x86_64" ]]; then
    # my MacBookPro 11,4 (15' Mid 2015)
    PATH_4+=":/Library/Apple/usr/bin"
else
    PATH_2+=":/System/Cryptexes/App/usr/bin"
    PATH_4+=":/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"
fi

true

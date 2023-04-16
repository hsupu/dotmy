
# brew
# export HOMEBREW_GITHUB_API_TOKEN=
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE=https://mirrors.ustc.edu.cn/brew.git
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export HOMEBREW_CORE_GIT_REMOTE=https://mirrors.ustc.edu.cn/homebrew-core.git

# java
[[ -z $JAVA_HOME ]] && JAVA_HOME="/Library/Java/Home"

# man
if [[ -d "/Applications/Wireshark.app" ]]; then
    MANPATH_1="${MANPATH_1}:/Applications/Wireshark.app/Contents/Resources/share/man"
    PATH_4="${PATH_4}:/Applications/Wireshark.app/Contents/MacOS"
fi

# python
if [[ -d $PYENV_ROOT ]]; then
    [[ -d "${PYENV_ROOT}/bin" ]] || ln -s "$(brew --prefix pyenv)/bin" "${PYENV_ROOT}/"
fi

# tex
# TEX_ROOT="/Library/TeX"
# PATH_2="${PATH_2}:${TEX_ROOT}/texbin"

# vmware
if [[ -d "/Applications/VMware Fusion.app" ]]; then
    PATH_4="${PATH_4}:/Applications/VMware Fusion.app/Contents/Public"
fi

PATH_4="${PATH_4}:/Library/Apple/usr/bin"

true

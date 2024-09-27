
# command line tools
xcode-select --install

# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/xp/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# rosetta, since M1
softwareupdate --install-rosetta --agree-to-license

brew install --cask iterm2
brew install --cask visual-studio-cde
brew install --cask firefox
brew install --cask google-chrome

brew install shadowsocks-rust
brew install v2ray-core
brew install \
    git git-lfs \
    tmux \
    vim \
    zsh

brew install bat

# 日用
#

brew install --cask snipaste
brew install --cask iina # 媒体播放器
brew install --cask jolpin
brew install --cask thorium # 阅读器
brew install --cask vnc-viewer
brew install --cask lark

# https://mounty.app/
brew install --cask macfuse
brew install gromgit/fuse/ntfs-3g-mac
brew install --cask mounty

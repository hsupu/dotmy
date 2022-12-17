# pyenv

pyenv 是一个 Python 版本控制工具，能够安装多个 Python 版本，并在 shell 中根据需要切换它们。

https://github.com/pyenv/pyenv

## 安装与更新

### Linux

pyenv-installer 是整合脚本

https://github.com/pyenv/pyenv-installer

```bash
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

#export PATH="/home/xp/.pyenv/bin:$PATH"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

pyenv update
```

具体版本和依赖 https://github.com/pyenv/pyenv/wiki#suggested-build-environment

```bash
sudo apt install -y build-essential
# or
sudo apt install -y clang

sudo apt install -y \
    curl fakeroot make pkg-config wget \
    libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev xz-utils libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

pyenv install 3.10.1

pyenv global 3.10.1
```

### Mac

```bash
brew install pyenv

brew update pyenv
```

### Windows

pyenv-win 是为 Windows 重写的 pyenv，使用方法略有不同。

https://github.com/pyenv-win/pyenv-win

```ps1
scoop install pyenv
```

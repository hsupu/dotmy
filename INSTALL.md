
## Ubuntu/Debian

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y git curl wget



mkdir -p ~/.config
git clone https://gitee.com/hsupu/dotmy.git --single-branch --branch main ~/.config/dotmy

~/.config/dotmy/shells/bash/install.sh
ln -s ~/.config/dotmy/profiles/current shell



mkdir -p ~/.local
export PYENV_ROOT="$HOME/.local/pyenv"
curl https://pyenv.run | bash
pyenv update

sudo apt install -y build-essential libreadline-dev libncurses5-dev libssl-dev zlib1g-dev libbz2-dev liblzma-dev xz-utils libsqlite3-dev libxml2-dev libxmlsec1-dev libffi-dev
# for GUI
# sudo apt install -y libncursesw5-dev  tk-dev
    
pyenv install 3.12.4
python -m pip install -U pip wheel setuptools python-dotenv

./remap.py
./remap.py --map-file overrides/wsl/mapping.py
```

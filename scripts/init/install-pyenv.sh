
mkdir -p ~/.local

export PYENV_ROOT="$HOME/.local/pyenv"
curl https://pyenv.run | bash

pyenv update

sudo apt install -y build-essential libreadline-dev libncurses5-dev libssl-dev zlib1g-dev libbz2-dev liblzma-dev xz-utils libsqlite3-dev libxml2-dev libxmlsec1-dev libffi-dev

# for GUI
# sudo apt install -y libncursesw5-dev  tk-dev
    
pyenv install 3.12.4
python -m pip install -U pip wheel setuptools python-dotenv

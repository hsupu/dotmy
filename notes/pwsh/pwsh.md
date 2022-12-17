# PowerShell Core

https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3

```bash
sudo apt-get install -y wget apt-transport-https software-properties-common

# Microsoft repository GPG keys
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install -y powershell
```

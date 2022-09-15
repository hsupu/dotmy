# podman

## Install on WSL

```bash
. /etc/os-release

sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${NAME}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${NAME}_${VERSION_ID}/Release.key | sudo apt-key add -

sudo apt-get update
sudo apt-get -qq -y install podman
```

```bash
sudo mkdir -p /etc/containers
echo -e "[registries.search]\nregistries = ['docker.io', 'quay.io']" | sudo tee /etc/containers/registries.conf
```

## 远程

```
podman system connection add default ssh://root@xp-vm-ub2004:22/run/podman/podman.sock --identity $HOME/.ssh/podman
```

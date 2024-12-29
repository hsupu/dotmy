
## Windows Containers

Windows 也提供了 [Windows Containers](https://learn.microsoft.com/zh-cn/virtualization/windowscontainers/) 支持，这是原生的、基于 Win32 而非 Linux 的。

Docker 工具可分两部分，[Docker Engine](https://docs.docker.com/engine/install/binaries/#install-server-and-client-binaries-on-windows) 和 [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)，前者负责运行容器，后者则提供了管理 GUI。

Docker Engine 基于 Hyper-V，需要在 BIOS 启用 CPU 虚拟化，安装 Microsoft-Hyper-V、Containers 两项 Windows Feature。

```ps1
# 这是 Docker Engine，手工的话可以去 https://download.docker.com/win/static/stable/x86_64 选择下载
scoop install docker
```

## Linux Containers on Windows

虽然 Docker Desktop 也支持，这里只讲 Podman CLI / Podman Desktop 方案。

file:///C:/Program%20Files/RedHat/Podman/podman-for-windows.html

```ps1
scoop install podman
podman machine init
```

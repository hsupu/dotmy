# WSL 自启服务

打开 wsl/cmd/pwsh，输入 `wsl.exe -l` 查看发行版名称，如 `Debian` `Ubuntu` `Ubuntu-18.04`。

创建 `/etc/init.wsl`，根据你的服务需求输入需要自启的程序：

```bash
#!/bin/sh
# crond
/etc/init.d/cron $1
# sshd
/etc/init.d/ssh $1
# supervisord
/etc/init.d/supervisor $1
```

需要配合 Windows 启动项，打开 `shell:startup` 目录，创建一个 `wsl.vbs`，输入以下内容：

```vbs
Set ws = CreateObject("Wscript.Shell")
ws.run "wsl -d Debian -u root /etc/init.wsl start", vbhide
```

这里的 `Debian` 就是刚刚的发行版名称。


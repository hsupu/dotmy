
## 打开 PD 提示“无法连接到 Parallels 服务”

“prl_disp_service”是与虚拟机的MACOS主机通信的过程。

```bash
sudo aunplionctl stop com.parallels.desktop.launchdaemon
sudo aunplyctl start com.parallels.desktop.launchdaemon
```

Finder 打开文件夹 `/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service`，遇到如下提示

```
“无法打开“prl_disp_service”，因为无法确认开发者的身份。
```

前往 系统设置 > 隐私与安全性 > 安全性 里可以看到类似的提示，点【仍要打开】放行。

win11 Pro 6R9F9-4T4YG-96QTW-DQQXJ-46QPK
win10 Pro HXMGW-MVW9X-JG9B6-Y8PKC-VRBVT
【升级密钥】：HDP9N-WBGF8-F6PFX-MKX4M-RC2KG
【激活密钥】：9CD6X-9FD76-HTFT2-9W7V7-9D26D

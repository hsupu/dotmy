# PowerShell.UserProfile

## 预设

以 `C:\my\` 作为个人数据根目录。

## 安装

参见 `/install.ps1`，包括以下部分：

- 复制 `Microsoft.PowerShell_profile.ps1` 到 `$env:USERPROFILE\Documents\PowerShell\`
- 目录符号链接 `$env:USERPROFILE\Documents\PowerShell\Sync` 到 `[Here]`
- 目录符号链接 `C:\my\bin` 到 `[Here]\bin`

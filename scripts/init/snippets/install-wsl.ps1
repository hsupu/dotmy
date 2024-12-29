<#
.LINK
https://learn.microsoft.com/en-us/windows/wsl/install
https://learn.microsoft.com/en-us/windows/wsl/install-on-server
#>
param()

# 现在 `wsl --install` 会自动完成这一步了
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux,VirtualMachinePlatform -All

& wsl --set-default-version 2
& wsl --install --no-distribution --web-download
& wsl --version
& wsl --list --online

Write-Host @"
通过以下命令安装最新的 Debian 发行版
& wsl --install Debian --no-launch --web-download

通过以下命令更新 WSL 内核版本
& wsl --update
& wsl --version
"@

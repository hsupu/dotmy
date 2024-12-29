<#
.NOTES
Windows Installer 包括几个部分

- InstallShield 置于 Program Files/Common Files/InstallShield/Engine，后台进程 ikernel.exe
- Windows Modules Installer Service (TrustedInstaller) 服务
#>

& msiexec /unregserver
& msiexec /regserver

Restart-Service TrustedInstaller

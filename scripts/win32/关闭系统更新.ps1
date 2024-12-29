
Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "NoAutoUpdate"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "NoAutoUpdate" -Type DWord -Value 1

Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Type DWord -Value 1

# 1 - 禁用 保持我的计算机最新
# 2 - 通知下载安装
# 3 - 自动下载、通知安装
# 4 - 自动下载、自动执行计划安装
Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 1

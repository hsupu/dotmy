<#
.NOTES
240728
很奇怪，可能是新增的保护机制，regedit.exe "cannot rename" reg.exe "access denied" 还是 PowerShell/C# 直接修改系统预留的注册表项会报错无权访问、 之类的，
但是自从 Settings -> For developers -> Developer mode 之后，就可以了。

.NOTES
最近打开的文档储存在
   %APPDATA%\Microsoft\Windows\Recent
   %APPDATA%\Microsoft\Windows\Recent Items
#>
param()

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# 配置 sysinfo.exe 中的值
# GetSetRegValue $hklmWCV "PlatformRole" "Desktop" "String"

# 启用开发者模式 https://learn.microsoft.com/en-us/windows/apps/get-started/developer-mode-features-and-debugging
GetSetRegValue $hklmWCVAppModelUnlock "AllowDevelopmentWithoutDevLicense" 1 "DWORD"
# 启用侧载
# GetSetRegValue $hklmWCVAppModelUnlock "AllowAllTrustedApps" 1 "DWORD"

# check developer mode
Show-WindowsDeveloperLicenseRegistration
# & readCloudDataSettings.exe get -type:Windows.Data.Apps.DeviceMetadata

# UI Shell
#

# 自动重启应用
GetSetRegValue $hkcuWCVWinLogon "RestartApps" 1 "DWORD"

# 登出时清除最近文档
GetSetRegValue $hkcuWCVPoliciesExplorer "ClearRecentDocsOnExit" 1 "DWORD"

# Get tips, tricks, and suggestions as you use Windows
GetSetRegValue $hkcuWCVContentDeliveryManager "SoftLandingEnabled" 0 "DWORD"
# Shows occasional suggestions in Start menu
GetSetRegValue $hkcuWCVContentDeliveryManager "SystemPaneSuggestionsEnabled" 0 "DWORD"

# Explorer
#

# 显示复选框 https://www.tenforums.com/tutorials/104025-enable-disable-auto-select-click-windows.html
GetSetRegValue $hkcuWCVExplorerAdvanced "AutoCheckSelect" 1 "DWORD"

# 显示隐藏文件
# 0 - hide, 1 - show
GetSetRegValue $hkcuWCVExplorerAdvanced "Hidden" 1 "DWORD"

# 显示空驱动器
GetSetRegValue $hkcuWCVExplorerAdvanced "HideDrivesWithNoMedia" 0 "DWORD"

# 显示扩展名
GetSetRegValue $hkcuWCVExplorerAdvanced "HideFileExt" 0 "DWORD"

# Show recently opened items in Jump Lists on Start, and in Quick Access in File Explorer
GetSetRegValue $hkcuWCVPoliciesExplorer "NoRecentDocsHistory" 1 "DWORD"

# 禁用 "Recent Items"
GetSetRegValue $hkcuWCVPoliciesExplorer "NoRecentDocsMenu" 1 "DWORD"

# 禁用 "Frequent Places"
GetSetRegValue $hkcuWCVPoliciesExplorer "NoRecentDocsNetHood" 1 "DWORD"

# Show files from Office.com in Quick Access (Windows 10) / Home (Windows 11 22H2)
GetSetRegValue $hkcuWCVExplorer "ShowCloudFilesInQuickAccess" 0 "DWORD"
# Show frequently used folders in Quick Access (Windows 10) / Home (Windows 11 22H2)
GetSetRegValue $hkcuWCVExplorer "ShowFrequent" 0 "DWORD"
# Show recently used files in Quick Access (Windows 10) / Home (Windows 11 22H2)
GetSetRegValue $hkcuWCVExplorer "ShowRecent" 0 "DWORD"
GetSetRegValue $hklmPoliciesExplorer "DisableGraphRecentItems" 1 "DWORD"

# Show recommended section in Home
GetSetRegValue $hkcuWCVExplorer "ShowRecommendations" 0 "DWORD"

# 不再记录最近文档
# 组策略 Computer Configuration\Administrative Templates\Start Menu and Taskbar :: Do not keep a history of recently opened documents
GetSetRegValue $hkcuWCVExplorerAdvanced "Start_TrackDocs" 0 "DWORD"

# 紧凑视图
GetSetRegValue $hkcuWCVExplorerAdvanced "UseCompactMode" 1 "DWORD"

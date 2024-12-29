<#
.SYNOPSIS
Windows 11 Widgets

.NOTES
进程名 Widgets.exe WidgetService.exe
#>
param()

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# 一劳永逸！
# & winget uninstall "Windows Web Experience Pack"

# 禁用桌面小组件
# 组策略 Computer Configuration\Administrative Templates\Windows Components\Widgets :: Allow widgets
GetSetRegValue $hkcuPoliciesDsh "AllowNewsAndInterests" 0 "DWORD"
# GetSetRegValue (Join-Path $hklmPolicyManagerDefault "NewsAndInterests\AllowNewsAndInterests") "Value" 0 "DWORD"

# 禁用桌面小组件的信息流
GetSetRegValue $hklmPoliciesWindowsFeeds "EnableFeeds" 0 "DWORD"

# 禁用任务栏右键菜单中的桌面小组件开关？
GetSetRegValue $hkcuWCVFeeds "IsFeedsAvailable" 0 "DWORD"

# 任务栏图标悬停打开桌面小组件
GetSetRegValue $hkcuWCVFeeds "ShellFeedsTaskbarOpenOnHover" 0 "DWORD"

# 桌面小组件呈现方式
# 0 - icon+text, 1 - icon, 2 - off
GetSetRegValue $hkcuWCVFeeds "ShellFeedsTaskbarViewMode" 2 "DWORD"

# 任务栏内容更新方式
# 0 - manual, 1 - automatic
GetSetRegValue $hkcuWCVFeeds "ShellFeedsTaskbarContentUpdateMode" 0 "DWORD"

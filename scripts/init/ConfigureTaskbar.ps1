<#
#>
param(
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# 任务栏对齐方式
# 0 - 左对齐, 1 - 居中
GetSetRegValue $hkcuWCVExplorerAdvanced "TaskbarAl" 0 "DWORD"

# 是否合并标签
# 0 - always, 1 - when full, 2 - never
# GetSetRegValue $hkcuWCVPoliciesExplorer "NoTaskGrouping" 1 "DWORD"
GetSetRegValue $hkcuWCVExplorerAdvanced "TaskbarGlomLevel" 2 "DWORD"
# 多屏时
GetSetRegValue $hkcuWCVExplorerAdvanced "MMTaskbarGlomLevel" 2 "DWORD"

# 多屏时如何显示标签
# 0 - show on all, 1 - show on main, 2 - show on opened
GetSetRegValue $hkcuWCVExplorerAdvanced "MMTaskbarMode" 2 "DWORD"

# 平板模式下，不自动隐藏
GetSetRegValue $hkcuWCVExplorerAdvanced "TaskbarAutoHideInTabletMode" 0 "DWORD"

# 隐藏小组件图标，Win+W 仍可打开
# 组策略 Computer Configuration\Administrative Templates\Windows Components\Widgets
GetSetRegValue $hkcuWCVExplorerAdvanced "TaskbarDa" 0 "DWORD"

# 隐藏 Chat 图标，Win+C 仍可打开
# 组策略 Computer Configuration\Administrative Templates\Windows Components\Chat
# for current user
GetSetRegValue $hkcuWCVExplorerAdvanced "TaskbarMn" 0 "DWORD"
# for all users
GetSetRegValue $hklmPoliciesWindowsChat "ChatIcon" 3 "DWORD"

# 隐藏 Copilot 图标
# 0 - hide, 1 - show
GetSetRegValue $hkcuWCVExplorerAdvanced "ShowCopilotButton" 0 "DWORD"

# 只显示搜索图标
# 0 - off, 1 - icon, 2 - box
GetSetRegValue $hkcuWCVSearch "SearchboxTaskbarMode" 1 "DWORD"

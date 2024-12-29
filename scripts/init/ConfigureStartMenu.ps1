<#
#>
param(
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# 更多图钉，而不是推荐
# 0 - default, 1 - more pins, 2 - more recommendations
GetSetRegValue $hkcuWCVExplorerAdvanced "Start_Layout" 1 "DWORD"

# 开始菜单显示文件夹
# https://learn.microsoft.com/en-us/windows/apps/develop/settings/settings-common#personalization---start---folders
$uuidSettings = [Guid]::Parse("52730886-51AA-4243-9F7B-2776584659D4")
$uuidExplorer = [Guid]::Parse("148A24BC-D60C-4289-A080-6ED9BBA24882")
$uuidUserProfile = [Guid]::Parse("74BDB04A-F94A-4F68-8BD6-4398071DA8BC")
$encoded = @(
    $uuidSettings,
    $uuidExplorer,
    $uuidUserProfile
) | % { $_.ToByteArray() }
GetSetRegValue $hkcuWCVStart "VisiblePlaces" $encoded "binary"

# 推荐
GetSetRegValue $hkcuWCVExplorerAdvanced "Start_IrisRecommendations" 0 "DWORD"

# Show recently added apps
GetSetRegValue $hklmPoliciesExplorer "HideRecentlyAddedApps" 1 "DWORD"

# "Most used" list
GetSetRegValue $hkcuWCVStart "ShowFrequentList" 0 "DWORD"
# "Recently added" list
GetSetRegValue $hkcuWCVStart "ShowRecentList" 1 "DWORD"

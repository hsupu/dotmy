<#
#>
param()

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# Search Box
#

# 禁用 Web 搜索建议/结果
# 组策略 Computer Configuration\Administrative Templates\Windows Components\Search :: Do not allow web search
# 组策略 Computer Configuration\Administrative Templates\Windows Components\Search :: Don't search the web or display web results in Search
GetSetRegValue $hkcuPoliciesExplorer "DisableSearchBoxSuggestions" 1 "DWORD"
# Win10 1607 or earlier
# GetSetRegValue $hklmPoliciesWindowsSearch "ConnectedSearchUseWeb" 0 "DWORD"
# Win10 1703-1803
# GetSetRegValue $hklmPoliciesWindowsSearch "AllowCortana" 0 "DWORD"
# Win10 1809-2004
# GetSetRegValue $hkcuWCVSearch "BingSearchEnabled" 0 "DWORD"

# 保存搜索历史纪录
GetSetRegValue $hkcuWCVSearchSettings "IsDeviceSearchHistoryEnabled" 1 "DWORD"
# 关闭搜索要点（Search Highlights）
GetSetRegValue $hkcuWCVSearchSettings "IsDynamicSearchBoxEnabled" 0 "DWORD"
# 不搜索 MSA 账户内容
GetSetRegValue $hkcuWCVSearchSettings "IsMSACloudSearchEnabled" 0 "DWORD"
# 禁用搜索结果审查
GetSetRegValue $hkcuWCVSearchSettings "SafeSearchMode" 0 "DWORD"

# Classic Search
#

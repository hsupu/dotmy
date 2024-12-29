<#
.SYNOPSIS
跳过文件/目录链接的复制脚本

.NOTES
explorer 复制文件链接会卡死，目录链接会拷贝，离谱！
#>
param(
    [Parameter(Mandatory, Position=0)]
    [string]$ListFilePath
)

$lines = Get-Content -LiteralPath $script:ListFilePath -Encoding utf8
foreach ($line in $lines) {
    Write-Output $lines
}

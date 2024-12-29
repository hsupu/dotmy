<#
.SYNOPSIS
Save or load environment variables to or from a JSON file.
#>
param(
    [string]$ProfileName,

    [string]$SaveBlacklist,

    [switch]$Load
)

$kvps = [ordered]@{}
Get-ChildItem "env:*" | Sort-Object -Property Key | ForEach-Object {
    $kvps[$_.Key] = $_.Value
} | Out-Null

$kvps | ConvertTo-Json

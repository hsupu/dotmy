param(
    [string]$RootPath,

    [switch]$Apply
)

if ('' -eq [string]$RootPath) {
    $RootPath = "E:\packagecache\VC17NOLTCG"
}

Get-ChildItem -LiteralPath $RootPath -Directory | % {
    Get-ChildItem -LiteralPath $_ -Directory | Sort-Object -Property CreationTime -Descending | Select-Object -Skip 2 | % {
        if ($Apply) {
            Remove-Item -LiteralPath $_ -Recurse -Force
        } else {
            $_.FullName
        }
    }
}

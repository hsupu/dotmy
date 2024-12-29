param(
    [Parameter(Mandatory)]
    [string]$Category
)

if ($Category -ieq 'rg') {
    Write-Host "Find & Replace: rg --passthru 'find' -r 'replace' srcfile > dstfile"
}

param(
    [Parameter(Mandatory)]
    $Path
)

Get-FileHash $Path -Algorithm SHA256 | Select-Object -Property Path,Hash | Format-List
return

# 替代方法：使用 certutil

$items = Get-Item -Path $Path
if (0 -eq $items.Count) {
    $items = Get-Item -LiteralPath $Path
}
Write-Host "Found $($items.Count) : $Path"

foreach ($item in $items) {
    & certutil -hashfile $item.FullName sha256
}

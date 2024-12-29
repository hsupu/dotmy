param(
    [Parameter(Mandatory, Position=0)]
    [string]$Path
)

$items = Get-Item $Path
if (0 -eq $items.Count) {
    $items = Get-Item -LiteralPath $Path
}
Write-Host "Found $($items.Count) : $Path"

$sh = New-Object -ComObject WScript.Shell
foreach ($item in $items) {
    $target = $sh.CreateShortCut($item.FullName)
    Write-Host $target
}

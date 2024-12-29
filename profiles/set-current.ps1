param()

$target = (& hostname).ToLower()

if ($target -ieq "xp-AMD") {
    $target = "xp-pc1"
}

$dir = Get-Item $PSScriptRoot
$current = (Join-Path $dir.FullName "current")

if (Test-Path $current) {
    $item = Get-Item $current
    if ($target -eq $item.LinkTarget) {
        return
    }

    Write-Warning "Existing: current => $($item.LinkTarget)"
    return
}

& cmd /c mklink /d $current $target

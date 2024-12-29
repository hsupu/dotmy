param(
    [Parameter(Mandatory, Position=0)]
    [string]$Path,

    [Parameter(Position=1)]
    [string]$Dst,

    [string]$DryRun
)

$items = @()
if ($Path -match '.*\*.*') {
    $escaped = $Path
    if ($escaped -match '.*\[.*\]') {
        $escaped = $escaped -replace '(?!`)\[', '`['
        $escaped = $escaped -replace '(?!`)\]', '`]'
        Write-Host 'escaped'
    }
    $items = @(Get-Item -Path $escaped -ErrorAction Stop)
}
if (0 -eq $items.Count) {
    $items = Get-Item -LiteralPath $Path -ErrorAction Stop
}
Write-Host "Found $($items.Count) : $Src"

if (0 -eq $Dst.Length) {
    $Dst = "."
}

foreach ($item in $items) {
    # -m : set param
    #   cp : codepage
    #
    # -scc : set charset for console
    # -scs : set charset for file list
    #
    # -sccUTF-8 -scsUTF-8
    & 7z x $item.FullName -o"$Dst\$($item.BaseName)" -mcp=936
}

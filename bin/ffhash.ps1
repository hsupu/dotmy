param(
    [Parameter(Mandatory, Position=0)]
    [string]$Path,

    [switch]$HashVideo
)

trap { throw $_ }

$items = $null

if ($Path -match '.*\*.*') {
    $escaped = $Path
    if ($escaped -match '.*\[.*\]') {
        $escaped = $escaped -replace '(?!`)\[', '`['
        $escaped = $escaped -replace '(?!`)\]', '`]'
        Write-Host 'escaped'
    }
    $items = @(Get-Item -Path $escaped -ErrorAction Stop)
}
if ((-not $items) -or (0 -eq $items.Count)) {
    $items = @(Get-Item -LiteralPath $Path -ErrorAction Stop)
}
Write-Host "Found $($items.Count) : $Path"

foreach ($item in $items) {
    Write-Host $item.FullName
    if ($HashVideo) {
        & ffmpeg -loglevel error -i $item.FullName -an -sn -map 0 -f streamhash -
    }
    else {
        # -hash md5
        & ffmpeg -loglevel error -i $item.FullName -vn -sn -map 0 -f streamhash -
    }
}

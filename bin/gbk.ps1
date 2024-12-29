param(
    [Parameter(Mandatory, Position=0)]
    $Path,

    [switch]$NoReplace
)

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
Write-Host "Found $($items.Count) : $Path"

# if (1 -ne $items.Count) {
#     Write-Error "Process only 1 file is by design"
#     return
# }

foreach ($srcItem in $items) {
    $text = Get-Content -LiteralPath $srcItem.FullName -Encoding "GBK" -ErrorAction Stop

    # -NewNoLine 在这儿不好使
    # Set-Content -LiteralPath $new -Value $text -Encoding "UTF-8"
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

    if ($NoReplace) {
        $new = Join-Path $srcItem.Directory.FullName "$($srcItem.BaseName).UTF8$($srcItem.Extension)"
        if (Test-Path -LiteralPath $new) {
            Write-Error "FileExist: $new" -ErrorAction Continue
            continue
        }
        [System.IO.File]::WriteAllLines($new, $text, $Utf8NoBomEncoding)
    }
    else {
        $orig = Join-Path $srcItem.Directory.FullName "$($srcItem.BaseName).orig$($srcItem.Extension)"
        if (Test-Path -LiteralPath $orig) {
            Write-Error "FileExist: $orig" -ErrorAction Continue
            continue
        }
        # Write-Host "Backup $orig"
        Move-Item -LiteralPath $srcItem.FullName -Destination $orig -ErrorAction Stop
        [System.IO.File]::WriteAllLines($srcItem.FullName, $text, $Utf8NoBomEncoding)
    }
}

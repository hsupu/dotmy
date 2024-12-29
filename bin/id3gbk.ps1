[CmdletBinding()]
param(
    [Parameter(Mandatory, Position=0)]
    $Path,

    [Parameter(ValueFromRemainingArguments)]
    [AllowEmptyCollection()]
    $Remaining # = $null
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

$venv = "Q:/rt/py/venv"
$py = "D:\ws\own\py\id3gbk\src\main.py"

foreach ($item in $items) {
    # Write-Host $item.FullName
    & cmd /c "`"$(Join-Path $venv "Scripts\activate.bat")`" && `"$(Join-Path $venv "Scripts\python.exe")`" `"$py`" `"$($item.FullName)`"" @Remaining
    if (0 -ne $LASTEXITCODE) {
        Write-Error "Failed with $LASTEXITCODE" -ErrorAction Stop
        throw
    }
}

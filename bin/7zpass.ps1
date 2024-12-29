param(
    [string]$PassFile,
    [string]$ZipFile,

    [switch]$DryRun
)

$passwords = @(Get-Content -LiteralPath $PassFile -Encoding UTF-8 -ErrorAction Stop)

$item = Get-Item -LiteralPath $ZipFile -ErrorAction Stop

foreach ($pass in $passwords) {
    $pass = $pass.Trim()
    if (0 -eq $pass.Length) {
        continue
    }

    Write-Host $pass

    $proc = (& 7z.exe t "-p$pass" $item.FullName | Out-Null)
    if (2 -eq $LASTEXITCODE) {
        continue
    }
    if (0 -ne $LASTEXITCODE) {
        Write-Error "Failed with $LASTEXITCODE" -ErrorAction Stop
        throw
    }

    Write-Host "Password: $pass"
    return
}

Write-Error "No password matched" -ErrorAction Stop
throw

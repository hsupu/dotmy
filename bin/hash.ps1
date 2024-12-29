param(
    [string]$Path
)

$results = Get-FileHash -LiteralPath $Path -Algorithm SHA256
foreach ($result in $results) {
    Write-Host "$($result.Hash) : $($result.Path)"
}

<#
.NOTES
TODO 允许输入文件夹
#>
param(
    [Parameter(Mandatory)]
    [string]$ListFile,

    [string]$OutFile = 'checksums.txt',

    [string]$HashAlgorithm = 'SHA1'
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$ListFile = Resolve-Path -ErrorAction Stop -LiteralPath $ListFile

$config = @{
    HashAlgorithm = $HashAlgorithm;
}
$outline = ($config | ConvertTo-Json -Compress).Trim('"')
$outline | Out-File -LiteralPath $OutFile

$lines = Get-Content -LiteralPath $ListFile
foreach ($line in $lines) {
    [string]$line = $line.Trim()
    if ('' -eq $line) {
        continue
    }

    if ($line.StartsWith('#')) {
        continue
    }

    $path = $line
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Write-Warning -WarningAction Continue "FileNotFound: $path"
        continue
    }

    $hash = (Get-FileHash -ErrorAction Stop -LiteralPath $path -Algorithm $HashAlgorithm).Hash.ToUpper()
    $outline = "$hash $path"
    $outline | Out-File -LiteralPath $OutFile -Append
}

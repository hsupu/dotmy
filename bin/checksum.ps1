<#
#>
param(
    [Parameter(Mandatory)]
    [string]$File,

    [string]$MismatchOutFile
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$File = Resolve-Path -ErrorAction Stop -LiteralPath $File
$lines = Get-Content -LiteralPath $File

$config = $lines[0] | ConvertFrom-Json -ErrorAction Stop -AsHashtable
$HashAlgorithm = $config['HashAlgorithm']

if ('' -ne $MismatchOutFile) {
    Set-Content -LiteralPath $MismatchOutFile -Value '' -NoNewline
}

$err_cnt = 0
foreach ($line in $lines[1..($lines.Length - 1)]) {
    [string]$line = $line.Trim()
    if ('' -eq $line) {
        continue
    }

    if ($line.StartsWith('#')) {
        continue
    }

    $expected, $path = $line.Split(' ', 2)

    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Write-Warning -WarningAction Continue "FileNotFound: $path"
        $err_cnt += 1
        continue
    }

    $hash = (Get-FileHash -ErrorAction Stop -LiteralPath $path -Algorithm $HashAlgorithm).Hash.ToUpper()
    if ($hash -ne $expected) {
        Write-Warning -WarningAction Continue "Mismatch: $path"
        $err_cnt += 1

        if ('' -ne $MismatchOutFile) {
            $outline = "$path"
            $outline | Out-File -LiteralPath $MismatchOutFile -Append
        }
    }
}

$passed = ($err_cnt -eq 0)
if ($passed) {
    Write-Output "Checksum passed"
}
else {
    $Host.UI.RawUI.ForegroundColor = "Red"
    $Host.UI.WriteErrorLine("Checksum not passed")
    exit 1
}

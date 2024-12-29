<#
.NOTES
241230
#>
param(
    [string]$HexPath,
    [string]$BinPath
)

$ErrorActionPreference = 'Stop'
trap { throw $_}

$HexPath = Resolve-Path -LiteralPath $HexPath

if (-not (Test-Path -LiteralPath $BinPath)) {
    $BinPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($BinPath)
}
else {
    $BinPath = Resolve-Path $BinPath
}

$file = [IO.File]::Open($BinPath, [IO.FileMode]::Create, [IO.FileAccess]::Write, [IO.FileShare]::Read)
try {
    # Get-Content -LiteralPath $HexPath | % { $line -replace '[\s"''\`\|-:,.]', '' } | ? { $_ -ne '' } | % {
    #     if ($_.Length % 2 -ne 0) {
    #         throw "Invalid hex string: $_"
    #     }
    #     [byte[]]$b = ($line -split '(.{2})' -replace '^', '0X')
    #     $file.Write($b, 0, $b.Length)
    # }

    $lines = Get-Content -LiteralPath $HexPath
    foreach ($line in $lines) {
        $line = ($line -replace '[\s"''\`\|-:,\.]', '')
        [byte[]]$b = ($line -split '(.{2})' -ne '' -replace '^', '0X')
        $file.Write($b, 0, $b.Length)
    }
}
finally {
    $file.Close()
}

param(
    [Parameter(Mandatory)]
    [Alias('c')]
    [string]$Path,

    [switch]$NoCopy,
    [switch]$NoRun,
    [switch]$NoConHost
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$exe = "C:\opt\sslocal.exe"
$ini = (Resolve-Path -LiteralPath $Path).ToString()
# Write-Host $orig
# Write-Host $ini

function CopySslocal {
    # $orig = & which sslocal.exe
    $orig = Join-Path (& scoop prefix shadowsocks-rust) "sslocal.exe"

    if (Test-Path -LiteralPath $exe) {
        if (-not (Test-Path -LiteralPath $orig)) {
            return # no orig to copy
        }
    }

    $origVer = & $orig --version
    if (0 -ne $LASTEXITCODE) {
        throw "$orig --version failed with exit code $LASTEXITCODE"
    }

    $exeVer = $null
    if (Test-Path -LiteralPath $exe) {
        $exeVer = & $exe --version
        if (0 -ne $LASTEXITCODE) {
            throw "$exe --version failed with exit code $LASTEXITCODE"
        }
    }

    if ([string]$origVer -eq [string]$exeVer) {
        return # unchanged
    }

    Copy-Item -ErrorAction Stop $orig $exe -Force
}

if (-not $script:NoCopy) {
    CopySslocal
}

if ($script:NoRun) {
    return
}

if ($script:NoConHost) {
    & $exe -c $ini @args
}
else {
    & conhost.exe $exe -c $ini @args
}

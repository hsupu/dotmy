param(
    [Parameter(Mandatory)]
    [Alias('c')]
    [string]$Path,

    [switch]$NoCopy
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$exe = "C:\opt\sslocal.exe"
$ini = (Resolve-Path -LiteralPath $Path).ToString()
# Write-Host $orig
# Write-Host $ini

function CopySslocal {
    # $orig = (& which sslocal.exe)
    $orig = Join-Path (& scoop prefix shadowsocks-rust) "sslocal.exe"

    if (Test-Path -LiteralPath $exe) {
        if (-not (Test-Path -LiteralPath $orig)) {
            return
        }
        if (-not $script:NoCopy) {
            return
        }
    }

    $origVer = (& $orig --version).Trim()
    if (0 -ne $LASTEXITCODE) {
        throw "$orig --version failed with exit code $LASTEXITCODE"
    }

    if (Test-Path -LiteralPath $exe) {
        $exeVer = (& $exe --version).Trim()
        if (0 -ne $LASTEXITCODE) {
            throw "$exe --version failed with exit code $LASTEXITCODE"
        }
    }

    if ($origVer -eq $exeVer) {
        return
    }

    Copy-Item -ErrorAction Stop $orig $exe -Force
}
CopySslocal

& conhost.exe $exe -c $ini @args
return

# /C - Treat string after /C as command, execute it and then terminates
# /K - Treat string after /K as command, execute it and then remains
# /S - Don't treat the only quote(") string specially
# /A - Make internal commands output ANSI
# /U - Make internal commands output Unicode
# /E:ON - Enable command extensions
# cmd /?

& conhost.exe cmd.exe /A /S /K "@" $exe -c $ini @args
return

# 等价于
# Start-Process conhost.exe -ArgumentList @(
#     "cmd.exe",
#     "/A /E:ON /S /K @ `"$exe`" -c `"$ini`""
# )
# return

# 如果用 powershell
# & conhost.exe powershell.exe -NoExit -Command "& `"$exe`" -c `"$ini`""
return

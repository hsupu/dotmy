param(
    [Parameter(Mandatory)]
    [Alias('c')]
    [string]$Path
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$exe = $(which sslocal.exe)
$ini = (Resolve-Path -LiteralPath $Path).ToString()
# Write-Host $exe
# Write-Host $ini

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

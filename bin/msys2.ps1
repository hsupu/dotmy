<#
.SYNOPSIS
查找并打开特定目标的 MSYS2 窗口
#>
param(
    [Parameter(Position=0)]
    [string]$MSystem,

    [Parameter(ValueFromRemainingArguments)]
    $Remaining
)

$DebugPreference = 'Continue'
$ErrorActionPreference = 'Stop'
trap { throw $_ }

if ([string]::IsNullOrEmpty($MSystem)) {
    if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
        $MSystem = "clangarm64"
    }
    else {
        $MSystem = "ucrt64"
    }
}
elseif ($MSystem.StartsWith('-')) {
    $MSystem = $MSystem.Substring(1)
}

if ($MSystem -ieq 'msys') {
    $MSystem = 'msys2'
}
elseif ($MSystem -ieq 'mingw') {
    $MSystem = 'mingw64'
}
elseif ($MSystem -ieq 'clang') {
    $MSystem = 'clang64'
}
elseif ($MSystem -ieq 'ucrt') {
    $MSystem = 'ucrt64'
}

$exeName = "msys2_shell.cmd"
$dirHints = @(
    "C:\opt\msys64",
    "C:\msys64",
    "$($env:SCOOP)\apps\msys2\current",
    "$HOME\scoop\apps\msys2\current"
)

foreach ($dirHint in $dirHints) {
    try {
        $path = Join-Path $dirHint $exeName
        if (Test-Path $path) {
            $script:exePath = Resolve-Path $path
            break
        }
    }
    catch {
        Write-Debug $_
        continue
    }
}

if ([string]::IsNullOrEmpty($exePath)) {
    throw 'No msys2 found'
}
# $exePath
Push-Location (Split-Path $exePath)

# activate windows native symlinks
$env:MSYS = (@("winsymlinks", "nativestrict") + $env:MSYS -split ':' | Select-Object -Unique) -join ':'

# equivalent to arg "-$MSystem"
# $env:MSYSTEM = $MSystem.ToUpper()

# Start MSYS2 config script
#
# shell type: -mingw32 -mingw64 -ucrt64 -clang64 -msys2
# as set MSYSTEM=
#
# term type: -defterm -mintty -conemu, we won't use another terminal here
# as set MSYSCON=
#
# -here - use curdir as workdir
# as set CHERE_INVOKING=enabled_from_arguments
#
# -use-full-path - inherit from windows envvar PATH
# as set MSYS2_PATH_TYPE=inherit
#
& $exePath "-$MSystem" @Remaining --% -defterm -here -no-start

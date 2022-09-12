param(
    [Parameter(Position=0)]
    [string]$MSystem,

    [Parameter(ValueFromRemainingArguments)]
    [object[]]$Remaining
)

$DebugPreference = 'Continue'
$ErrorActionPreference = 'Stop'
trap { throw $Error[0]; }

if ([string]::IsNullOrEmpty($MSystem)) {
    $MSystem = "ucrt64"
}
elseif ($MSystem.StartsWith('-')) {
    $MSystem = $MSystem.Substring(1)
}

$exeName = "msys2_shell.cmd"
$dirHints = @(
    "C:\my\local\opt\msys64",
    "C:\my\opt\msys64",
    "C:\msys64",
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
    Write-Error 'No msys2 found'
    return
}

# activate windows native symlinks
$env:MSYS = "winsymlinks:nativestrict:$($env:MSYS)"

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

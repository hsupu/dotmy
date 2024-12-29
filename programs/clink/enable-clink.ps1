<#
.NOTES
chcp 后 WSL2 似乎会乱码，这个方案一般不要用
#>
param(
    [switch]$GetOnly
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

if ($GetOnly) {
    & clink autorun show
    return
}

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/chcp
GetSetRegValue $hklmCmd "AutoRun" "@chcp 65001 >nul"

$value = "`"$(Join-Path $env:SCOOP 'apps\clink\current\clink.bat')`" inject --autorun --profile `"$(Join-Path $env:SCOOP 'programs\clink')`""
GetSetRegValue $hkcuCmd "AutoRun" $value

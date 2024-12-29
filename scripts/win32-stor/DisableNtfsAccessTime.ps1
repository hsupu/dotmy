<#
#>
param()

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# disabled by default since win8
GetSetRegValue $hklmFileSystem "NtfsDisableLastAccessUpdate" 1 "DWORD"

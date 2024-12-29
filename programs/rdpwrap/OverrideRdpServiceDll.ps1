<#
#>
param(
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# if error 126 - The specified module could not be found
GetSetRegValue $hklmTermService "ServiceDll" "%SystemRoot%\System32\termsrv.dll" "ExpandString"

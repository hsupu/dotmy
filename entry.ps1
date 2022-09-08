
# see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.1#erroractionpreference
$ErrorActionPreference = 'Stop'
trap { throw $Error[0]; }

# Specify cmdlets
# see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.1#psdefaultparametervalues
# $PSDefaultParameterValues += @{
#     "Get-Function:ErrorAction" = "Stop"
#     "Get-Command:ErrorAction" = "Stop"
#     "Get-MyFunction*:ErrorAction" = "Stop"
# }

$srcs = @(
    "$PSScriptRoot\env-vars.ps1",
    "$PSScriptRoot\cmdlets\*.ps1",
    "$PSScriptRoot\mod\*.ps1",
    "$PSScriptRoot\completers\*.ps1", # postponed to make it work for aliases
    "$PSScriptRoot\local\entry.ps1"
)

# PowerShell Gallery rejects TLS < 1.2 since 2020-04, we force to use TLS 1.2 here
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Import-Module PSProfiler

foreach ($src in $srcs) {
    $files = Get-ChildItem $src -ErrorAction SilentlyContinue
    if ($null -eq $files) { continue }

    foreach ($file in $files) {
        if (-not (Test-Path $file)) { continue }

        if (Test-Path env:DEBUG_PWSH_PROFILE_LOADING) {
            Write-Host -NoNewLine "Loading $file"
            $time = Measure-Command { . $file }
            Write-Host " in $($time.TotalSeconds)s"
        }
        else {
            . $file
        }
    }
}

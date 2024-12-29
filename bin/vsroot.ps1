<#
.NOTES
241110
Install-Module -Scope CurrentUser VSSetup
#>
param(
    [Parameter(ValueFromPipeline=$true)]
    [Microsoft.VisualStudio.Setup.Instance]$Instance,

    [switch]$PreRelease
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

if ($null -eq $Instance) {
    $inss = Get-VSSetupInstance -All -Prerelease | Sort-Object -Property InstallationVersion -Descending
    foreach ($ins in $inss) {
        if ($ins.State -ne [Microsoft.VisualStudio.Setup.Configuration.InstallationState]::Complete) {
            continue
        }
        $Instance = $ins
        break
    }

    if ($null -eq $Instance) {
        throw "No VS instance selected"
    }
}

$Instance.InstallationPath

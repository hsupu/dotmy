# Add the following line to "$($env:USERPROFILE)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
# see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.1

# . "C:\my\sync\dotmy\shells\pwsh\entry.ps1"
# . "$PSScriptRoot\Sync\shells\pwsh\entry.ps1"
if ((Test-Path -LiteralPath env:DOTMY) -and ('' -ne [string]$env:DOTMY)) {
    . "$($env:DOTMY)\shells\pwsh\entry.ps1"
}
else {
    Write-Warning -WarningAction Continue "`$env:DOTMY not defined, skip to load user profile"
}

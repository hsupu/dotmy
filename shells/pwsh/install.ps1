param()

$ErrorActionPreference = 'Stop'
trap { throw $_ }

if ($env:OS -ne 'Windows_NT') {
    throw "NotImpl: Not a Windows."
}

Write-Host "Remeber to enable `"Developer Mode`" in system `"Settings`" first, to make symlinks work"

$env:DOTMY = Resolve-Path (Join-Path $PSScriptRoot "../..")

New-Item -ErrorAction SilentlyContinue -ItemType Directory -Path "$HOME\Documents\PowerShell" | Out-Null
Copy-Item -ErrorAction Stop "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" "$HOME\Documents\PowerShell\" | Out-Null
# & cmd /c mklink /d "$HOME\Documents\PowerShell\Sync" $env:DOTMY

$psmPath = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "modules")
Write-Host "Please run the following commands in new pwsh:"
Write-Host "Add-PSModulePath `"$($psmPath)`" # WindowsPowerShell will fail"

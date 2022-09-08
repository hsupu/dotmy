param()

$ErrorActionPreference = 'Stop'
trap { throw $Error[0]; }

if ($env:OS -ne 'Windows_NT') {
    Write-Error "NotImpl: Not a Windows."
    exit(1)
}

Write-Host "Remeber to enable `"Developer Mode`" in system `"Settings`" first, to make symlinks work"

mkdir -p $HOME\Documents\PowerShell -ErrorAction SilentlyContinue
Copy-Item "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" "$HOME\Documents\PowerShell\"
& cmd /c mklink /d "$HOME\Documents\PowerShell\Sync" $PSScriptRoot

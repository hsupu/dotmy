# Install-Module -Scope CurrentUser VSSetup
param()

$instance = Get-VSSetupInstance -All -Prerelease | Select-Object -First 1
if ($null -eq $instance) {
    $instance = Get-VSSetupInstance -All | Select-Object -First 1
}

if ($null -eq $instance) {
    Write-Error "Failed to Get-VSSetupInstance"
    exit(1)
}
Write-Host "Using $($instance.InstallationPath)"

& cmd.exe /K \"$($instance.InstallationPath)\Common7\Tools\VsDevCmd.bat" @args

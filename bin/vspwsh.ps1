# Install-Module -Scope CurrentUser VSSetup
param()

if (Test-Path env:VCINSTALLDIR) {
    Write-Host "already is VS DevShell"
    exit(0)
}

# not work for msbuild
# see: https://github.com/dotnet/msbuild/issues/1596
$env:DOTNET_CLI_UI_LANGUAGE = "en-US"
$env:VSLANG = "1033"
# chcp 65001

$instance = Get-VSSetupInstance -All -Prerelease | Select-Object -First 1
if ($null -eq $instance) {
    $instance = Get-VSSetupInstance -All | Select-Object -First 1
}

if ($null -eq $instance) {
    Write-Error "Failed to Get-VSSetupInstance"
    exit(1)
}
Write-Host "Using $($instance.InstallationPath)"

# Approach 1
# & pwsh.exe -NoLogo -NoExit -f "$($instance.InstallationPath)\Common7\Tools\Launch-VsDevShell.ps1" @args

# Approach 2
# https://docs.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell?view=vs-2022
Import-Module (Join-Path $vsInstance.InstallationPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")

$shParams = @{
    VsInstanceId = $vsInstance.InstanceId;
    Arch = "amd64";
    HostArch = "amd64";
    SkipAutomaticLocation = $true;
    # DevCmdArguments = "-arch=amd64";
}
Enter-VsDevShell @shParams

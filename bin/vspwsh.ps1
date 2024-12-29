<#
.SYNOPSIS
Locate and start Developer PowerShell for Visual Studio

.NOTES
241110

.NOTES
Install-Module -Scope CurrentUser VSSetup

#>
param(
    [switch]$NoNewSession
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

# since MSVC is what we need, so check it directly rather than VSINSTALLDIR
if (Test-Path env:VCINSTALLDIR) {
    throw "Already is VS DevShell"
}

# not work for msbuild
# see: https://github.com/dotnet/msbuild/issues/1596
$env:DOTNET_CLI_UI_LANGUAGE = "en-US"
$env:VSLANG = "1033"
# chcp 65001

$inss = Get-VSSetupInstance -All -Prerelease | Sort-Object -Property InstallationVersion -Descending
foreach ($ins in $inss) {
    if ($ins.State -ne [Microsoft.VisualStudio.Setup.Configuration.InstanceState]::Complete) {
        continue
    }
    $selected = $ins
    break
}

if ($null -eq $selected) {
    throw "No VS instance selected"
}
Write-Host $ins.InstallationPath

if ($NoNewSession) {
    # https://docs.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell?view=vs-2022
    Import-Module (Join-Path $ins.InstallationPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")

    $shParams = @{
        # VsInstanceId = $ins.InstanceId;
        VsInstallPath = $ins.InstallationPath;
        Arch = "amd64";
        HostArch = "amd64";
        SkipAutomaticLocation = $true;
        # DevCmdArguments = $args; # e.g. "-arch=amd64"
    }
    Enter-VsDevShell @shParams
}
else {
    $isPwsh = $PSVersionTable.PSVersion -ge [Version]::Parse("6.0")
    $exe = if ($isPwsh) { "pwsh" } else { "powershell" }
    $exeParams = @{
        # ParameterSet in Launch-VsDevShell.ps1, better than VsInstanceId which calls vswhere who doesn't support BuildTools
        # VsInstanceId = $ins.InstanceId;
        VsInstallationPath = $ins.InstallationPath;
        Arch = "amd64";
        HostArch = "amd64";
        SkipAutomaticLocation = $true;
    }
    & $exe -NoLogo -NoExit -f "$($ins.InstallationPath)\Common7\Tools\Launch-VsDevShell.ps1" @exeParams
}

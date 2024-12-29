<#
.LINK
https://devblogs.microsoft.com/powershell/windows-powershell-2-0-deprecation/
#>

$script:hasModuleServerManager = (Get-Command Get-WindowsFeature -ErrorAction SilentlyContinue)
$script:isClientSKU = (-not $script:hasModuleServerManager)

function SwitchWindowsFeature
{
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [switch]$Disable
    )

    if ($script:isClientSKU) {
        $state = (Get-WindowsOptionalFeature -Online -FeatureName $Name).State
        if (($state -eq "Enabled") -and $Disable) {
            Disable-WindowsOptionalFeature -Online -FeatureName $Name
        }
        elseif (($state -eq "Disabled") -and (-not $Disable)) {
            Enable-WindowsOptionalFeature -Online -FeatureName $Name
        }
    }
    else {
        $state = (Get-WindowsFeature -Online -FeatureName $Name).InstallState
        if (($state -eq "Installed") -and $Disable) {
            Remove-WindowsFeature -Name $Name
        }
        elseif (($state -eq "Removed") -and (-not $Disable)) {
            Install-WindowsFeature -Name $Name
        }
    }
}

if ($script:isClientSKU) {
    SwitchWindowsFeature -Name "MicrosoftWindowsPowerShellV2" -Disable
}
else {
    SwitchWindowsFeature -Name "PowerShell-V2" -Disable
}

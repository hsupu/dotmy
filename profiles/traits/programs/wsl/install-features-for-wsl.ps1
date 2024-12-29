<#
.LINK
https://learn.microsoft.com/en-us/windows/wsl/install
https://github.com/microsoft/WSL/issues/9411 : Disabled Windows Subsystem for Linux Optional Component after updating to store version
#>
[CmdletBinding()]
param(
)

function Test-Win10
{
    $os = [System.Environment]::OSVersion
    if ($os.Platform -ne 'Win32NT') {
        return $false
    }
    if ($os.Version.Major -ne 10) {
        return $false
    }
    if ($os.Version.Build -ge 22000) {
        return $false
    }
    return $true
}

$script:hasModuleServerManager = (Get-Command Get-WindowsFeature -ErrorAction SilentlyContinue)
$script:isClientSKU = (-not $script:hasModuleServerManager)
$script:isWin10 = (Test-Win10)
$global:RebootRequired = $false

function Test-Admin
{
    param(
        [switch]$NoThrow
    )
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($currentUser)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin -and -not $NoThrow) {
        throw "Required to be run as Administrator"
    }
    return $isAdmin
}

function Install-Feature
{
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    if ($script:hasModuleServerManager) {
        $feature = Get-WindowsFeature $Name
        if ($feature.Installed) {
            Write-Output "Feature $Name is in state $($feature.InstalledState)."
            return
        }

        Write-Output "Enabling feature $Name ..."
        $feature = Add-WindowsFeature $Name
        if ($feature.RestartNeeded -eq "Yes") {
            $global:RebootRequired = $true
        }
    }
    else {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $Name
        if ($feature.State -ne "Disabled") {
            Write-Output "Feature $Name is in state $($feature.State)."
            if ($script:isNanoSKU) {
                # Get-WindowsEdition is not present on Nano.  On Nano, we assume reboot is not needed
            }
            elseif ((Get-WindowsEdition -Online).RestartNeeded) {
                $global:RebootRequired = $true
            }
        }
        elseif ($script:isNanoSKU) {
            throw "Please install appropriate packages into the Nano image for feature ${Name}."
        }
        else {
            Write-Output "Enabling feature $Name ..."
            $feature = Enable-WindowsOptionalFeature -Online -FeatureName $Name -All -NoRestart
            if ($feature.RestartNeeded -eq "True") {
                $global:RebootRequired = $true;
            }
        }
    }
}

function main
{
    Test-Admin

    try {
        if ($script:isClientSKU) {
            Write-Host "Client SKU requires feature Hyper-V"
            $script:HyperV = $true
        }

        Install-Feature -Name VirtualMachinePlatform

        if ($script:isWin10) {
            # it's required feature for WSL 2 on Windows 10, but only needed for WSL 1 support on Windows 11, which is not my case
            Install-Feature -Name Microsoft-Windows-Subsystem-Linux
        }

        if ($global:RebootRequired) {
            Write-Host "Reboot required.  Please reboot the machine."
        }

    }
    catch {
        Write-Error -ErrorAction Stop "$($_.ToString())`n$($_.ScriptStackTrace)"
    }
}

main

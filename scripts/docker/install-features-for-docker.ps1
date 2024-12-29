<#
.LINK
https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1
#>
[CmdletBinding()]
param(
    [switch]$UseHyperV
)

function Test-Nano {
    $EditionId = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'EditionID').EditionId
    return ($false `
        -or ($EditionId -eq "ServerStandardNano") `
        -or ($EditionId -eq "ServerDataCenterNano") `
        -or ($EditionId -eq "NanoServer") `
        -or ($EditionId -eq "ServerTuva") `
        -or $false)
}

$script:isNanoSKU = (Test-Nano)
$script:hasModuleServerManager = (Get-Command Get-WindowsFeature -ErrorAction SilentlyContinue)
$script:isClientSKU = (-not ($script:hasModuleServerManager -or $script:isNanoSKU))

$script:RebootRequired = $false

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
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    if ($script:hasModuleServerManager) {
        $feature = Get-WindowsFeature $Name
        if ($feature.Installed) {
            Write-Output "Feature $Name is in state $($feature.InstalledState)."
            if ((Get-WindowsEdition -Online).RestartNeeded) {
                $script:RebootRequired = $true
            }
            return
        }
        else {
            Write-Output "Enabling feature $Name ..."
            $feature = Add-WindowsFeature $Name
            if ($feature.RestartNeeded -eq "Yes") {
                $script:RebootRequired = $true
            }
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
                $script:RebootRequired = $true
            }
        }
        elseif ($script:isNanoSKU) {
            throw "Please install appropriate packages into the Nano image for feature ${Name}."
        }
        else {
            Write-Output "Enabling feature $Name ..."
            $feature = Enable-WindowsOptionalFeature -Online -FeatureName $Name -All -NoRestart
            if ($feature.RestartNeeded -eq "True") {
                $script:RebootRequired = $true
            }
        }
    }
}

function main
{
    Test-Admin

    try {
        if ($script:isClientSKU) {
            Write-Host "Client SKU requires feature Hyper-V since it doesn't support process-level isolation."
            $script:UseHyperV = $true
        }

        if ($script:UseHyperV) {
            Install-Feature -Name Microsoft-Hyper-V
        }

        Install-Feature -Name Containers
    }
    catch {
        Write-Error -ErrorAction Stop "$($_.ToString())`n$($_.ScriptStackTrace)"
    }

    if ($script:RebootRequired) {
        Write-Host "Reboot is required to complete the installation."
    }
}

main

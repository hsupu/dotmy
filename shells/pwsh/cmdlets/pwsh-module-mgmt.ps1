
function global:Add-PSModulePath([string]$path) {
    $PSModulePathUser = [System.Environment]::GetEnvironmentVariable('PSModulePath', [System.EnvironmentVariableTarget]::User)
    if ($null -ne $PSModulePathUser) {
        $paths = $PSModulePathUser.Split(';')
        if ($path -in $paths) {
            Write-Host "Already existed: $paths"
            return
        }
        $paths += @($path)
    }
    else {
        $paths = @($path)
    }

    # https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.host.pshostuserinterface.promptforchoice?view=powershellsdk-7.2.0
    $choices = @("&No", "&Yes")
    $choice = $Host.UI.PromptForChoice('Add-PSModulePath', $paths, $choices, -1)
    if ($choice -lt 1) {
        Write-Host "Cancelled"
        return
    }

    $pathString = [string]::Join(";", $paths)
    [System.Environment]::SetEnvironmentVariable("PSModulePath", $pathString, [System.EnvironmentVariableTarget]::User)
    Write-Host "Updated user PSModulePath: $paths"
}

function global:List-UpgradableModules {
    param(
        [switch]$IncludeDowngrade
    )

    $installed = Get-InstalledModule
    $result = [Collections.Generic.List[object]]::new()
    foreach ($module in $installed) {
        try {
            $inGallery = Find-Module -Name $module.Name -Repository PSGallery
        }
        catch {
            Write-Host "$($module.Name) not found in PSGallery"
            continue
        }

        if ($inGallery.Version -ne $module.Version) {
            if ($inGallery.Version -gt $module.Version) {
                $append = $true
            }
            elseif ($IncludeDowngrade) {
                $append = $true
            }

            if ($append) {
                $result.Add($inGallery) | Out-Null
            }
        }
    }
    return $result
}

function global:Upgrade-Modules {
    $installed = List-UpgradableModules
    $installed | Update-Module
}

function global:Clean-StaleModules([switch]$WhatIf) {
    $installed = Get-InstalledModule
    foreach ($module in $installed) {
        $siblings = Get-InstalledModule $module.Name -AllVersions -AllowPrerelease
        foreach ($sibling in $siblings) {
            if ($sibling.Version -ne $module.Version) {
                if ($WhatIf) {
                    Uninstall-Module -InputObject $sibling -AllowPrerelease -WhatIf
                }
                else {
                    Write-Host "Uninstalling $($sibling.Name) $($sibling.Version)"
                    Uninstall-Module -InputObject $sibling -AllowPrerelease
                }
            }
        }
    }
}

function global:Install-MyModules
{
    param(
        [switch]$Update
    )

    $isPwsh = ([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("6.0")) -ge 0

    if (-not $Update) {
        # https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-7.2
        # new solution of package management, can be installed with PowerShellGet side-by-side.
        if ($isPwsh) {
            if (([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("7.4")) -ge 0) {
                # Pre-installed since 7.4
            }
            else {
                Install-Module "Microsoft.PowerShell.PSResourceGet" -Repository "PSGallery"
            }
        }
        else {
            # https://learn.microsoft.com/en-us/powershell/gallery/powershellget/update-powershell-51?view=powershellget-3.x
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
            # requires run-as-admin
            Install-PackageProvider -Name "NuGet" -Force
            # alternative way
            # Install-Module -Scope AllUsers -Force "PowerShellGet" -AllowClobber
        }
    
        Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

        & scoop install PSReadLine
        # Install-Module -Scope CurrentUser PSReadLine -AllowPrerelease -Force
        Install-Module -Scope CurrentUser "Microsoft.PowerShell.ConsoleGuiTools"
        Install-Module -Scope CurrentUser "VSSetup"
        Install-Module -Scope CurrentUser "InvokeBuild"
        Install-Module -Scope CurrentUser "Use-RawPipeline"
        Install-Module -Scope CurrentUser "posh-git" -AllowClobber
        Install-Module -Scope CurrentUser "npm-completion"
        Install-Module -Scope CurrentUser "Get-ChildItemColor" -AllowClobber
    }
    else {
        # Update-Module -Scope AllUsers "PowerShellGet"

        & scoop update PSReadLine
        # Update-Module -Scope CurrentUser PSReadLine -AllowPrerelease -Force
        Update-Module -Scope CurrentUser "Microsoft.PowerShell.ConsoleGuiTools"
        Update-Module -Scope CurrentUser "VSSetup"
        Update-Module -Scope CurrentUser "InvokeBuild"
        Update-Module -Scope CurrentUser "Use-RawPipeline"
        Update-Module -Scope CurrentUser "posh-git" -AllowClobber
        Update-Module -Scope CurrentUser "npm-completion"
        Update-Module -Scope CurrentUser "Get-ChildItemColor" -AllowClobber
    }
}

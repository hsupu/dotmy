
function List-UpgradableModules()
{
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

function Upgrade-Modules()
{
    $installed = List-UpgradableModules
    $installed | Update-Module
}

function Clean-StaleModules([switch]$WhatIf)
{
    $installed = Get-InstalledModule
    foreach ($module in $installed) {
        $siblings = Get-InstalledModule $module.Name -AllVersions
        foreach ($sibling in $siblings) {
            if ($sibling.Version -ne $module.Version) {
                if ($WhatIf) {
                    Uninstall-Module -InputObject $sibling -WhatIf
                }
                else {
                    Write-Host "Uninstalling $($sibling.Name) $($sibling.Version)"
                    Uninstall-Module -InputObject $sibling
                }
            }
        }
    }
}

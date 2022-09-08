# https://github.com/dahlbyk/posh-git
#
# Install-Module -Scope CurrentUser posh-git -AllowClobber
#
try {
    # Get-InstalledModule is too slow to use
    if ($null -eq (Get-Module posh-git)) {
        throw
    }
}
catch {
    Write-Debug "posh-git not found, skip Import-Module"
    return
}

if (Test-Path env:NO_POSH_GIT) {
    Write-Debug "env:NO_POSH_GIT found, skip Import-Module"
    return
}

Import-Module posh-git

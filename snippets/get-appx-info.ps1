param(
    [string]$Name
)

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_windows_powershell_compatibility?view=powershell-7.3
Import-Module -Name Appx -UseWindowsPowerShell

# $session = Get-PSSession -Name WinPSCompatSession
# Invoke-Command -Session $session -ScriptBlock {
#     "Running in Windows PowerShell version $($PSVersionTable.PSVersion)"
# }

$pkg = Get-AppxPackage -Name $Name
Write-Output $pkg.InstallLocation
Write-Output $pkg.PackageFamilyName

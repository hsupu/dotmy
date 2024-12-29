param(
    [switch]$FeatContainers
)

$isWindowsServer = (Get-ComputerInfo).WindowsServer

& winget install --source winget Microsoft.VisualStudioCode
& winget install --source winget Microsoft.PowerShell
& winget install --source winget Microsoft.WindowsTerminal
& winget install --source winget Microsoft.OneDrive
& winget install --source winget Microsoft.PowerToys
& winget install --source winget Microsoft.VisualStudio.2022.Enterprise
# & winget install --source winget Microsoft.VisualStudio.2022.BuildTools
# & winget install --source winget Microsoft.VisualStudio.2022.TestAgent

if ($isWindowsServer) {
    Install-WindowsFeature -Name Hyper-V -IncludeManagementTools

    if ($FeatContainers) {
        Install-WindowsFeature -Name Containers
    }
}
else {
    # & DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V

    # -Online : Targets the running operating system
    # -All : Install all dependent features
    Enable-WindowsOptionalFeature -Online -FeatureName @("Microsoft-Hyper-V") -All

    if ($FeatContainers) {
        Enable-WindowsOptionalFeature -Online -FeatureName @("Containers") -All
    }
}

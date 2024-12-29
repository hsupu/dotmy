param(
    [switch]$Disable
)

$isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Requires to run as Administrator"
}

# https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/nested-virtualization
Set-VMProcessor -VMName win10-ae -ExposeVirtualizationExtensions (-not $Disable)

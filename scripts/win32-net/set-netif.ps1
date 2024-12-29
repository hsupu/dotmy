param(
    [string]$NetAdapterName,

    [string]$IPv4,
    [short]$IPv4PrefixLength,

    [string]$IPv6,
    [short]$IPv6PrefixLength,

    [switch]$DryRun
)

$netif = Get-NetAdapter -Name $NetAdapterName
if ($null -eq $netif) {
    return
}

if (-not [string]::IsNullOrWhiteSpace($IPv4)) {
    if (0 -eq $IPv4PrefixLength) {
        $IPv4PrefixLength = 24
    }
    $netif | New-NetIPAddress -AddressFamily IPv4 -IPAddress $IPv4 -PrefixLength $IPv4PrefixLength
}

if (-not [string]::IsNullOrWhiteSpace($IPv6)) {
    if (0 -eq $IPv6PrefixLength) {
        $IPv6PrefixLength = 64
    }
    $netif | New-NetIPAddress -AddressFamily IPv6 -IPAddress $IPv6 -PrefixLength $IPv6PrefixLength
}

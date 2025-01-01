<#

.NOTES
netsh.exe interface ipv6 set interface help 可以看到 PowerShell Set-NetIPInterface 的等价命令
netsh.exe interface ipv6 set interface <alias-or-index> forwarding=enabled

等价于 PowerShell Verb-NetRoute
netsh interface ipv6 show route
netsh interface ipv6 add route $Subnet $if.ifIndex metric=256

等价于 PowerShell Verb-Service
sc.exe config RemoteAccess start= auto
sc.exe start RemoteAccess

.NOTES
241228

#>
param()

$ErrorActionPreference = 'Stop'
trap { throw $_ }

# $Prefix = "fec0:7870:7773:6c00" # site-local
$Prefix = "fd00:7870:7773:6c00" # unique-local
$PrefixLength = 56
$Subnet = "${Prefix}::/$PrefixLength"
$HstIp6 = "${Prefix}::1"
$WslIp6 = "${Prefix}::2"

$ifs = @(Get-NetAdapter -Name "vEthernet (WSL*)")
if (0 -eq $ifs.Count) {
    throw "No WSL interfaces found, not running?"
}
if (1 -ne $ifs.Count) {
    $ifs | Format-List
    throw "Got $($ifs.Count) WSL interfaces"
}
$if = $ifs[0]

# 如需，启用 IPv6
$comp = Get-NetAdapterBinding -Name $if.Name -ComponentID ms_tcpip6
if ($comp.Enabled -eq $false) {
    Enable-NetAdapterBinding -Name $if.Name -ComponentID ms_tcpip6
}

$ips = Get-NetIPAddress -InterfaceIndex $if.ifIndex -AddressFamily IPv6
$ips | Format-List

# 重置 IPv6 静态地址
Remove-NetIPAddress $HstIp6
# 这会输出两次新 IP，没有一次是最终状态
New-NetIPAddress -InterfaceIndex $if.ifIndex -IPAddress $HstIp6 -PrefixLength $PrefixLength

$ip6 = Get-NetIPAddress -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -SuffixOrigin Manual
if ($ip6.IPAddress -ne $HstIp6) {
    throw "IPv6 address mismatch: $($ip6.IPAddress) != $HstIp6"
}

# Get-NetIPInterface -AddressFamily IPv6
$netif = Get-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6
$netif | Format-List

# 设置路由优先级（越低越优先）
Set-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -InterfaceMetric 25

Set-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -Forwarding Enabled
# 弱主机模式允许源 IP 为非当前接口本地的包通过
Set-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -WeakHostSend Enabled -WeakHostReceive Enabled

# SLAAC
Set-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -RouterDiscovery Enabled

# DHCPv6 -ManagedAddressConfiguration for 地址分配 -OtherStatefulConfiguration for 其他信息
Set-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -Dhcp Disabled
Set-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -ManagedAddressConfiguration Enabled -OtherStatefulConfiguration Enabled
Set-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -Dhcp Enabled -ManagedAddressConfiguration Enabled -OtherStatefulConfiguration Enabled

Set-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6 -Advertising Enabled -AdvertiseDefaultRoute Enabled -IgnoreDefaultRoutes Enabled

$netif = Get-NetIPInterface -InterfaceIndex $if.ifIndex -AddressFamily IPv6
$netif | Format-List

# Get-NetRoute -AddressFamily IPv6
Get-NetRoute -InterfaceIndex $if.ifIndex -AddressFamily IPv6

$route = Get-NetRoute -InterfaceIndex $if.ifIndex -DestinationPrefix $Subnet
$route | Format-List

# 设置路由优先级（越低越优先）
# -Publish for 将其包含在路由通告中
Set-NetRoute -InputObject $route -Publish Age -RouteMetric 25

$route = Get-NetRoute -InterfaceIndex $if.ifIndex -DestinationPrefix $Subnet
$route | Format-List

# 转发服务
# ========

& reg.exe query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IPEnableRouter"
& reg.exe query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "IPEnableRouter"
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "IPEnableRouter" /t REG_DWORD /d "1"
& reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /f /v "IPEnableRouter" /t REG_DWORD /d "1"

$svc = Get-Service RemoteAccess
if ($svc.Status -eq "Running") {
    Stop-Service RemoteAccess
}
Set-Service RemoteAccess -StartupType AutomaticDelayed
Start-Service RemoteAccess

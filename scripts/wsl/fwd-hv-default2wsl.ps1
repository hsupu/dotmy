<#
.NOTES
未验证

.NOTES
vEthernet (Default Switch) 和 vEthernet (WSL) 每次重启都会寻找一个空的网段，无法设置固定 IP

#>

$if1 = Get-NetIPInterface -InterfaceAlias "vEthernet (WSL*)"
$if1 | Select-Object ifIndex, InterfaceAlias, AddressFamily, ConnectionState, Forwarding
# tracert 成功；ping 仍失败
$if1 | Set-NetIPInterface -Forwarding Enabled -Verbose

$if2 = Get-NetIPInterface -InterfaceAlias "vEthernet (Default Switch)"
$if2 | Select-Object ifIndex, InterfaceAlias, AddressFamily, ConnectionState, Forwarding
# tracert 成功；ping 成功
$if2 | Set-NetIPInterface -Forwarding Enabled -Verbose

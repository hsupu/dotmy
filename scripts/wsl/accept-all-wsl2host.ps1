<#
.NOTES
防火墙有三种配置 Domain / Private (Standard) / Public
注册表位置如 HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile

关闭特定接口在特定配置下的防火墙，WSL 默认是 Public 且不可改，所以尝试这个办法
Set-NetFirewallProfile -Name "Public" -DisabledInterfaceAliases $if.ifAlias

但是重启后失效，因为网络接口被重建了，旧的失效了。

.NOTES
防火墙规则可以有多种过滤规则
- Address
- Application
- Interface
- InterfaceType
- Port
- Security
- Service
- Profile

.NOTES
探索

# 复杂点
$vmswitch = Get-VMSwitch -Name "WSL*" -SwitchType Internal
$vport = Get-NetFirewallHyperVPort -SwitchName $vmswitch.Id -NetworkType NAT
$creator = Get-NetFirewallHyperVVMCreator -VMCreatorId $vport.VMCreatorId
if ($creator.FriendlyName -ne "WSL") {
    throw "Non-WSL VMCreator: $($creator.FriendlyName)"
}

Remove-NetFirewallHyperVRule "vm-wsl-accept-in"
Remove-NetFirewallHyperVRule "vm-wsl-accept-out"
New-NetFirewallHyperVRule -Name "vm-wsl-accept-in" -DisplayName "HVWSL" -Direction Inbound -Action Allow -VMCreatorId $vport.VMCreatorId
New-NetFirewallHyperVRule -Name "vm-wsl-accept-out" -DisplayName "HVWSL" -Direction Outbound -Action Allow -VMCreatorId $vport.VMCreatorId

#>
param()

$isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Requires to run as Administrator"
}

# 随版本变化，有两种情况：
#   - "vEthernet (WSL)"
#   - "vEthernet (WSL (Hyper-V firewall))"
$ifs = @(Get-NetAdapter -Name "vEthernet (WSL*)")
if (0 -eq $ifs.Count) {
    throw "No WSL interfaces found, not running?"
}
if (1 -ne $ifs.Count) {
    $ifs | Format-List
    throw "Got $($ifs.Count) WSL interfaces"
}
$if = $ifs[0]

$rules = @(Get-NetFirewallRule -ErrorAction Continue -DisplayName "WSL")
if (0 -ne $rules.Count) {
    Remove-NetFirewallRule $rules
}
$rule = New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias $if.ifAlias -Action Allow -EdgeTraversalPolicy Allow -LocalOnlyMapping $true

# 检查以确保这规则只对 WSL 接口生效
if ((Get-NetFirewallInterfaceFilter -AssociatedNetFirewallRule $rule).InterfaceAlias -ne $if.ifAlias) {
    throw "Unexpected firewall rule: not associated with the WSL interface"
}

# Set-NetFirewallRule -NewDisplayName "WSL-in-any" -DisplayName "WSL"

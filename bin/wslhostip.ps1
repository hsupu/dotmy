param(
    [switch]$V
)

# 随版本变化，有两种情况：
#   - "vEthernet (WSL)"
#   - "vEthernet (WSL (Hyper-V firewall))"
$ifs = @(Get-NetAdapter -Name "vEthernet (WSL*)")
if (1 -ne $ifs.Count) {
    $ifs | Format-List
    throw "Got $($ifs.Count) WSL interfaces"
}
$if = $ifs[0]

$ips = @(Get-NetIPAddress -InterfaceIndex $if.ifIndex)

if ($V) {
    $ips | Format-List
    return
}
else {
    $ips | Select-Object -ExpandProperty IPAddress
}

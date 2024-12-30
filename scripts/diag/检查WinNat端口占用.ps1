param()

Write-Host "查看配置的征用范围"
& netsh interface ipv4 show dynamicportrange tcp
& netsh interface ipv4 show dynamicportrange udp
# 一般 IPv4 IPv6 相同，且配置自动跟随，这里不看了
# & netsh interface ipv6 show dynamicportrange tcp
# & netsh interface ipv6 show dynamicportrange udp

Write-Host "查看已征用的范围"
& netsh interface ipv4 show excludedportrange protocol=tcp
& netsh interface ipv4 show excludedportrange protocol=udp
# & netsh interface ipv6 show excludedportrange protocol=tcp
# & netsh interface ipv6 show excludedportrange protocol=udp

Write-Host @"
可能的处理方法（需要管理员权限）

netsh interface ipv4 set dynamicportrange tcp startport=30000 numberofports=10000 store=persistent
netsh interface ipv4 set dynamicportrange udp startport=49152 numberofports=16384 store=persistent
sc stop WinNat
sc start WinNat
"@
return
# PowerShell 对应的方法是 Get-NetTCPSetting Get-NetUDPSetting

Set-NetTCPSetting -DynamicPortRangeStartPort 30000 -DynamicPortRangeNumberOfPorts 10000
Set-NetUDPSetting -DynamicPortRangeStartPort 49152 -DynamicPortRangeNumberOfPorts 16384
Restart-Service WinNat

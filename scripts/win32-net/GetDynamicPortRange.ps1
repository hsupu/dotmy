param()

& netsh interface ipv4 show dynamicportrange tcp
& netsh interface ipv4 show dynamicportrange udp

& netsh interface ipv6 show dynamicportrange tcp
& netsh interface ipv6 show dynamicportrange udp

Write-Host @"
Follow-ups:

By netsh:
    sudo netsh interface ipv4 set dynamicportrange tcp startport=51559 numberofports=16384 store=persistent
    sudo netsh interface ipv4 set dynamicportrange udp startport=49152 numberofports=16384 store=persistent
    sudo netsh interface ipv6 set dynamicportrange tcp startport=51559 numberofports=16384 store=persistent
    sudo netsh interface ipv6 set dynamicportrange udp startport=49152 numberofports=16384 store=persistent

  By PowerShell:
    Set-NetTCPSetting -DynamicPortRangeStartPort 51559 -DynamicPortRangeNumberOfPorts 26000
    Set-NetUDPSetting -DynamicPortRangeStartPort 49152 -DynamicPortRangeNumberOfPorts 16384

"@

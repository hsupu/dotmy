
# operational
$logName = 'Microsoft-Windows-WinNat/Oper'
$log = [System.Diagnostics.Eventing.Reader.EventLogConfiguration]::new($logName)
$log.IsEnabled = $true
$log.SaveChanges()

Write-Host @"
Print logs by:
  Get-WinEvent -ProviderName `"Microsoft-Windows-WinNat`" | Format-List

If log shows `"NAT instance <xxx> failed to allocate a <TCP|UDP> port dynamically`",
consider check dynamic port range by:
  netsh interface ipv4 show dynamicportrange tcp
  netsh interface ipv4 show dynamicportrange udp
  netsh interface ipv6 show dynamicportrange tcp
  netsh interface ipv6 show dynamicportrange udp
"@

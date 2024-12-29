
$ErrorActionPreferenceOld = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
# RunWith PS 5.1
Import-Module SmbShare
$ErrorActionPreference = $ErrorActionPreferenceOld
Remove-Variable ErrorActionPreferenceOld

Get-SmbServerConfiguration

Write-Host "Follow-ups:`n"
Write-Host "Disable SMBv1"
Write-Host "`tSet-SmbServerConfiguration -EnableSMB1Protocol `$false"
Write-Host "`tor"
Write-Host "`tSet-ItemProperty -Path `"HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters`" SMB1 -Type DWORD -Value 0 -Force"

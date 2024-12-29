
$regKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator"
$regName = "NoActiveProbe"

Set-ItemProperty -Path $regKey -Name $regName -Value 1 -Type DWord

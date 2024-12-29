
$wmi = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID = 'C:'")

$cim = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID = 'C:'")

param(
    [string]$PNPDeviceID
)

# $device = Get-PnpDevice -InstanceId $PNPDeviceID
# $device | Out-Default | Write-Host

if ([string]::IsNullOrEmpty($PNPDeviceID)) {
    # "Processor"
    Get-PnpDevice -Class @("DiskDrive", "SCSIAdapter", "Display", "Net") -PresentOnly | Sort-Object -Property @("Class", "InstanceId") -Stable | ForEach-Object {
        $p = Get-PnpDeviceProperty -InstanceId $_.PNPDeviceID -KeyName "DEVPKEY_Device_Numa_Node" -ErrorAction Continue
        if ($p -and (Get-Member -InputObject $p -MemberType Property -Name "Data")) {
            "NUMA=$($p.Data) Class=$($_.Class) Name=$($_.FriendlyName) Id=$($_.InstanceId))"
        }
        else {
            "NUMA=* Class=$($_.Class) Name=$($_.FriendlyName) Id=$($_.InstanceId))"
        }
    }
    return
}

$p = Get-PnpDeviceProperty -InstanceId $PNPDeviceID -KeyName "DEVPKEY_Device_Numa_Node"
if ($p -and (Get-Member -InputObject $p -MemberType Property -Name "Data")) {
    $p.Data
}

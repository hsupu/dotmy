param(
    [string]$Name,

    [switch]$DryRun
)

New-VMSwitch -Name VmNAT -SwitchType Internal
New-NetNat -Name LocalNAT -InternalIPInterfaceAddressPrefix “192.168.100.0/24”

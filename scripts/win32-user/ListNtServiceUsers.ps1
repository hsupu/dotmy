
Get-WMIObject Win32_Service `
| where { $true `
    -and ($_.startname -ne "NT AUTHORITY\LocalService") `
    -and ($_.startname -ne "NT AUTHORITY\NetworkService") `
    -and ($_.startname -ne "localSystem") } `
| select `
    @{
        Name = "ServiceAccount";
        Expression = { ( $_.startname ) };
    },
    @{
        Name = "DispalyName";
        Expression = { ( $_.name ) }
    },
    StartMode,
    State,
    Status `
| Format-Table -AutoSize

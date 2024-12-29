<#
.DESCRIPTION
加入 AAD 后会出现几个无法解析的用户，同时导致 Get-LocalGroupMember 无法正常工作。

.LINK
https://github.com/PowerShell/PowerShell/issues/2996
https://superuser.com/questions/1131901/get-localgroupmember-generates-error-for-administrators-group

#>
param(
    [Parameter(Mandatory)]
    [string]$GroupName
)

Get-CimInstance -Class Win32_ComputerSystem -Property Domain, Name | Select-Object -Property Domain, Name

# $ComputerName = $env:COMPUTERNAME
# $query = "Associators of {Win32_Group.Domain='$ComputerName',Name='$GroupName'} where Role=GroupComponent"
# Get-CimInstance -Query $query -ComputerName $ComputerName

Get-CimInstance -ClassName Win32_Group -Filter "Name=`"$GroupName`""

$users = ([ADSI]"WinNT://./$GroupName").psbase.Invoke('Members') | % {
    # $_.GetType().InvokeMember('AdsPath', 'GetProperty', $null, $($_), $null)
    ([ADSI]$_).InvokeGet('AdsPath')
}

foreach ($user in $users)
{
    if ($user.StartsWith("WinNT://")) {
        $user = $user.Substring(8)
    }

    if ($false `
        -or ($user -like "$env:COMPUTERNAME/*") `
        -or ($user -like "$env:USERDOMAIN/*") `
        -or ($user -like "AzureAd/*") `
        -or ($user -like "MicrosoftAccount/*") `
        -or $false) {
        # known user
        continue
    }

    if ($user -match "S-1") {
        # empty or orphaned SIDs
        Write-Host $user
        # Remove-LocalGroupMember -Group $GroupName -Member $user
        continue
    }
    Write-Warning "Other kind of user: $user"
}

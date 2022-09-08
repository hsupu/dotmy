
$ErrorActionPreferenceOld = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
    ${function:~} = { Set-Location ~ }
    ${function:Go-ParentLocation} = { Set-Location .. }; Set-Alias ".." Go-ParentLocation # ".." is special
    ${function:...} = { Set-Location ..\.. }
    ${function:....} = { Set-Location ..\..\.. }
    ${function:.....} = { Set-Location ..\..\..\.. }
    ${function:......} = { Set-Location ..\..\..\..\.. }
}
finally {
    $ErrorActionPreference = $ErrorActionPreferenceOld
    Remove-Variable ErrorActionPreferenceOld
}


$ErrorActionPreferenceOld = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
    function global:~() { Set-Location ~ }
    # ".." is special
    function globale:Go-ParentLocation() { Set-Location .. }
    Set-Alias ".." Go-ParentLocation -Scope Global
    function global:...() { Set-Location ..\.. }
    function global:....() { Set-Location ..\..\.. }
    function global:.....() { Set-Location ..\..\..\.. }
    function global:......() { Set-Location ..\..\..\..\.. }
}
finally {
    $ErrorActionPreference = $ErrorActionPreferenceOld
    # Remove-Variable ErrorActionPreferenceOld
}

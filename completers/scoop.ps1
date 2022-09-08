# https://github.com/Moeologist/scoop-completion
#
# scoop bucket add extras
# scoop install scoop-completion
#
$modulePath = $null
try {
    if ($null -eq (Get-Command scoop)) {
        throw
    }
    $scoopRoot = $(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName
    $modulePath = Join-Path $scoopRoot "modules\scoop-completion"
    if (-not (Test-Path $modulePath)) {
        throw
    }
}
catch {
    Write-Debug "scoop/scoop-completion not found, skip Import-Module"
    return
}

Import-Module $modulePath

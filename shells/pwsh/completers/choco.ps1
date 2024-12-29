# https://ch0.co/tab-completion
#
if (-not (Test-Path env:ChocolateyInstall)) {
    return
}
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (-not (Test-Path $ChocolateyProfile)) {
    return
}
Import-Module "$ChocolateyProfile"

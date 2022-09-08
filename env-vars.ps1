
# $env:HOME = $env:USERPROFILE
$env:USER = $(whoami)
$env:SHELL = "pwsh"

if (Test-Path env:SHLVL) {
    $env:SHLVL = [int]$env:SHLVL + 1
}
else {
    $env:SHLVL = 1
}

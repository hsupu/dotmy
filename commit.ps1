param()

$choices = @('&Yes', '&No')
$decision = $Host.UI.PromptForChoice('git commit --amend', 'Are you sure to override commit by using latest time', $choices, 1)
if (0 -ne $decision) {
    exit(0)
}

Push-Location $PSScriptRoot
try {
    & git commit --amend --no-edit --date $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}
finally {
    Pop-Location
}

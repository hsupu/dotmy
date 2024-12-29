# https://github.com/ajeetdsouza/zoxide
# instead of "z"
#
try {
    if ($null -eq (Get-Command zoxide)) {
        throw
    }
}
catch {
    Write-Information "zoxide not found"
    return
}

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})

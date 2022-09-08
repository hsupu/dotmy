
if ($env:ENABLE_OH_MY_POSH -ne '1') {
    Write-Debug 'oh-my-posh not enabled'
    return
}

try {
    if ($null -eq (Get-Command oh-my-posh)) {
        throw
    }
}
catch {
    Write-Information "oh-my-posh not found"
    return
}

# $conf = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/v$(oh-my-posh --version)/themes/jandedobbeleer.omp.json"
$conf = "$PSScriptRoot\oh-my-posh.json"
oh-my-posh --init --shell pwsh --config $conf | Invoke-Expression

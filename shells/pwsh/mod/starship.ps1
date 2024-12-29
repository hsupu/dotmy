
try {
    if ($null -eq (Get-Command starship)) {
        throw
    }
}
catch {
    Write-Information "starship not found"
    return
}

function Invoke-Starship-PreCommand {
    $host.ui.Write("`e]0;pwsh $PWD`a")
}

function Reload-Starship {
    $env:STARSHIP_CONFIG = "$PSScriptRoot/starship.toml"
    Invoke-Expression (& starship init powershell)
}

Reload-Starship

param()

$ErrorActionPreference = 'Stop'
trap { throw $_ }

function main {

    if (-not (Test-Path -LiteralPath ".\rdpwrap.new.ini" -PathType Leaf)) {
        Write-Output "No new config found"
        return
    }

    Stop-Service -ErrorAction Stop "UmRdpService"
    Stop-Service -ErrorAction Stop "TermService"
    try {
        Move-Item -ErrorAction Stop ".\rdpwrap.ini" ".\rdpwrap.$(Get-Date -Format "yyMMdd-HHmmss").ini"
        Move-Item -ErrorAction Stop ".\rdpwrap.new.ini" ".\rdpwrap.ini"
    }
    finally {
        Start-Service -ErrorAction Stop "TermService"
    }

}

Push-Location $PSScriptRoot
try {
    main
}
finally {
    Pop-Location
}

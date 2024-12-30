<#
.NOTES
& python -m pip install afdko
#>
param(
    [string]$OutName
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

if ('' -eq $OutName) {
    $OutName = "Sarasa-PU"
}

$dir = "out"
$ttfs = Get-Item ".\$dir\Sarasa*.ttf" | % { $_.FullName }

# Sarasa 官方使用 js otb-ttc-bundle 而非 py afdko/otf2otc
& pyenv exec otf2otc -t "'CFF '=2" -o "$OutName.ttc" @ttfs
if (0 -ne $LASTEXITCODE) {
    throw "pyenv exec otf2otc exited with code $LASTEXITCODE"
}

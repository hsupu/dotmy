<#
.NOTES
& python -m pip install afdko
#>
param(
    [string]$OutName
)

if ('' -eq $OutName) {
    $OutName = "Iosevka-PU"
}

$dir = "dist\IosevkaCustom\ttf"
$ttfs = Get-Item ".$dir\IosevkaCustom-*.ttf" | % { $_.FullName }

# Sarasa 官方使用 js otb-ttc-bundle 而非 py afdko/otf2otc
& pyenv exec otf2otc -t "'CFF '=2" -o "$OutName.ttc" @ttfs

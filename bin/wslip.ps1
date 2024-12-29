param(
    [Alias('d')]
    [string]$Distro
)

$wsl = "C:\Windows\system32\wsl.exe"
$wslArgs = @()

if ('' -ne [string]$Distro) {
    $wslArgs += ("-d", $Distro)
}

# -d <distrib>
# -e <cmd>
# & wsl -e ip -4 route list scope link | wsl -e awk '{print $7}'
& $wsl @wslArgs -e bash -c "ip -4 route list scope link | awk '{print `$7}'"

param(
    [Parameter(Mandatory, Position=0)]
    [string]$Distro
)

if (-not [string]::IsNullOrEmpty($Distro)) {
    ${function:wsl} = {
        Write-Host $args
        return & C:\Windows\system32\wsl.exe -d $Distro @args
    }
}

# -d <distrib>
# -e <cmd>
# & wsl -e ip -4 route list scope link | wsl -e awk '{print $7}'
& wsl -e bash -c "`" ip -4 route list scope link | awk '{print `$7}' `""

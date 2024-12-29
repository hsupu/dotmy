param()

$isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Requires to run as Administrator"
}

& sfc /scannow

& DISM /Online /English /Cleanup-Image /CheckHealth
& DISM /Online /English /Cleanup-Image /ScanHealth
& DISM /Online /English /Cleanup-Image /RestoreHealth

# 如果不是处理当前系统
# & DISM /Online /Cleanup-Image /RestoreHealth /Source:G:\Sources\install.wim

param(
    [int]$Level = 0
)

trap {
    throw "$_`n$($_.ScriptStackTrace)"
}

# Ring0 - essential, even msstore is not available
#
if ($Level -lt 0) { return }

& scoop install gsudo
# & winget install --source winget gerardog.gsudo

# 权限放行
& sudo winget settings --enable LocalManifestFiles
& sudo winget settings --enable InstallerHashOverride
& sudo winget settings --enable ProxyCommandLineOptions

# & winget settings proxy reset
# & winget settings proxy set https://127.0.0.1:2345

# CLI & TUI
& scoop install PSReadline
& winget install --source winget Microsoft.PowerShell
& winget install --source winget Microsoft.WindowsTerminal

# 文本编辑
& winget install --source winget Microsoft.VisualStudioCode

# Ring1 - basic
#
if ($Level -lt 1) { return }

if ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
    & winget update --source winget Microsoft.VCRedist.2015+.x64
    & winget update --source winget Microsoft.VCRedist.2015+.x86
}
elseif ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
    & winget update --source winget Microsoft.VCRedist.2022.arm64
}

# 系统增强/桌面集成/效率工具
& winget install --source winget Microsoft.PowerToys
& winget install --source winget RandyRants.SharpKeys
& winget install --source winget voidtools.Everything
& winget install --source msstore 9P1WXPKB68KX # Snipate
# & winget install --source msstore 9NBLGGH3ZBJQ # Ditto Clipboard
& winget install --source msstore 9PNMNF92JNFP # 1Remote
& scoop install windirstat

# 第二信道访问
& scoop install shadowsocks-rust
& winget install --source winget Mozilla.Firefox
& winget install --source winget Vivaldi.Vivaldi

# 硬件监测/装机工具
& scoop install cpu-z
& scoop install hwinfo
& scoop install crystaldiskinfo
# & scoop install crystaldiskmark
& scoop install openhardwaremonitor
# & winget install --source winget BornToBeRoot.NETworkManager
# & scoop install networkmanager
& scoop install rufus

# CLI & TUI
& scoop install caddy
& scoop install delta
& scoop install grep
& scoop install iperf3
& scoop install starship
& scoop install wget
& scoop install which

# GUI
& scoop install imhex

# Ring2 - advanced
#
if ($Level -lt 2) { return }

# CLI & TUI
& scoop install clink
& scoop install bat
& scoop install fzf
& scoop install zoxide

# GUI
& winget install --source winget wingetui

# OBS & plugins
& scoop install obs-studio
# https://github.com/iamscottxu/obs-rtspserver/blob/master/README_zh-CN.md
& winget install --exact --id iamscottxu.obs-rtspserver
# https://github.com/DistroAV/DistroAV/wiki/1.-Installation
& winget install --exact --id NDI.NDIRuntime

# Ring3 - optional
#
if ($Level -lt 3) { return }

# 系统增强/桌面集成
& winget install --source winget StartIsBack.StartAllBack
& winget install --source winget Yuanli.uTools
& winget install --source winget LiErHeXun.Quicker # 付费

# 产品控制
# & winget install --source winget AD2F1837.HPDisplayCenter_v10z8vjag6ke6 # HP Display Center
& winget install --source winget Logitech.OptionsPlus
# & winget install --source winget Samsung.SamsungMagician

param()

& winget settings --enable LocalManifestFiles
& winget settings --enable InstallerHashOverride

& winget install --source winget Microsoft.PowerShell
& winget install --source winget gerardog.gsudo
& winget install --source winget Microsoft.WindowsTerminal
& winget install --source winget Microsoft.VisualStudioCode
& winget install --source winget RandyRants.SharpKeys
# & winget install --source winget 7zip.7zip
& winget install --source winget Daum.PotPlayer
& winget install --source winget Nevcairiel.LAVFilters

& winget install --source winget Google.Chrome

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

irm get.scoop.sh | iex
& scoop install git
& scoop bucket add extras
& scoop install openhardwaremonitor
& scoop install shadowsocks-rust


# suffix '/' matters
$mapping = @(
    @('$($env:APPDATA)/Code/User/settings.json', 'programs/vscode/settings.json'),
    @('$($env:LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json', 'programs/WindowsTerminal/settings.json'),
    @('$HOME/.m2', 'C:/opt/m2/'),
    @('$HOME/.nuget', 'C:/opt/nuget/UserHome/'),
    @('$HOME/.vscode', 'C:/opt/vscode/UserHome/'),
    @('$HOME/Documents/PowerShell', 'C:/opt/PowerShell/'),
    # @('$HOME/Documents/WeChat Files', 'C:/opt/Tencent/WeChat Files/'),
    @('$($env:APPDATA)/Code', 'C:/opt/vscode/Roaming/'),
    @('$($env:APPDATA)/GitHub Desktop', 'C:/opt/github-desktop/Roaming/'),
    @('$($env:APPDATA)/JetBrains', 'C:/opt/JetBrains/Roaming/'),
    @('$($env:APPDATA)/Mozilla', 'C:/opt/Mozilla/Roaming/'),
    @('$($env:APPDATA)/nuget', 'C:/opt/nuget/Roaming/'),
    @('$($env:APPDATA)/Tencent', 'C:/opt/Tencent/Roaming/'),
    @('$($env:LOCALAPPDATA)/JetBrains', 'C:/opt/JetBrains/Local/'),
    @('$($env:LOCALAPPDATA)/Mozilla', 'C:/opt/Mozilla/Local/'),
    @('$($env:LOCALAPPDATA)/nuget', 'C:/opt/nuget/Local/'),
    @('$($env:LOCALAPPDATA)/Tencent', 'C:/opt/Tencent/Local/'),
    @()
)

$includes = @(
    'traits-msft',
    'traits:devenv',
    'traits:wsl',
    'traits'
)

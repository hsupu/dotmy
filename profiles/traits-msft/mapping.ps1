
# suffix '/' matters
$mapping = @(
    @('$($env:APPDATA)/Code/User/keybindings.json', 'programs/vscode/keybindings.json'),
    @('$($env:LOCALAPPDATA)/Drop.App', 'C:/opt/msft/Drop.App/'),
    @('$($env:LOCALAPPDATA)/Symbol.App', 'C:/opt/msft/Symbol.App/'),
    @()
)

if (Test-Path -LiteralPath env:OneDriveCommercial) {
    $mapping += @(
        @('C:/my/bin-work', '$($env:OneDriveCommercial)/my/bin-work/'),
        # @('C:/my/notes', '$($env:OneDriveCommercial)/my/notes/'),
        # @('C:/my/start', '$($env:OneDriveCommercial)/my/start/'),
        @('C:/my/scripts', '$($env:OneDriveCommercial)/my/scripts/'),
        @('C:/my/var', '$($env:OneDriveCommercial)/my/var/'),
        @()
    )
}

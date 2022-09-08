# PowerShell.UserProfile

## install

Run `/install.ps1`, which does:

- Copy `Microsoft.PowerShell_profile.ps1` to `$env:USERPROFILE\Documents\PowerShell\`
- Create Symlink from dir `$env:USERPROFILE\Documents\PowerShell\Sync` to `[InstallRoot]`

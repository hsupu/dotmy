
function Install-MyAdminModules()
{
    # https://docs.microsoft.com/en-us/powershell/scripting/gallery/installing-psget?view=powershell-7.2
    Install-PackageProvider -Name NuGet -Force
    Install-Module -Scope AllUsers PowerShellGet
    Set-PSRepository -Name “PSGallery” -InstallationPolicy Trusted
}

function Update-MyAdminModules()
{
    Update-Module -Scope AllUsers PowerShellGet
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

function Install-MyModules()
{
    Install-Module -Scope CurrentUser PSReadLine -AllowPrerelease -Force
    Install-Module -Scope CurrentUser Microsoft.PowerShell.ConsoleGuiTools
    Install-Module -Scope CurrentUser VSSetup
    Install-Module -Scope CurrentUser InvokeBuild
    Install-Module -Scope CurrentUser Use-RawPipeline
    Install-Module -Scope CurrentUser posh-git -AllowClobber
    Install-Module -Scope CurrentUser npm-completion
    Install-Module -Scope CurrentUser Get-ChildItemColor -AllowClobber
}

function Update-MyModules()
{
    Update-Module -Scope CurrentUser PSReadLine -AllowPrerelease -Force
    Update-Module -Scope CurrentUser Microsoft.PowerShell.ConsoleGuiTools
    Update-Module -Scope CurrentUser VSSetup
    Update-Module -Scope CurrentUser InvokeBuild
    Update-Module -Scope CurrentUser Use-RawPipeline
    Update-Module -Scope CurrentUser posh-git -AllowClobber
    Update-Module -Scope CurrentUser npm-completion
    Update-Module -Scope CurrentUser Get-ChildItemColor -AllowClobber
}

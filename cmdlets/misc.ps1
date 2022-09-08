
function Upgrade-PowerShell()
{
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
}

function Edit-Profile([switch]$AllUser, [switch]$AllHost)
{
    if ($AllUser) {
        if ($AllHost) {
            $filename = $PROFILE.AllUsersAllHosts;
        }
        else {
            $filename = $PROFILE.AllUsersCurrentHost;
        }
    }
    else {
        if ($AllHost) {
            $filename = $PROFILE.CurrentUserAllHosts;
        }
        else {
            $filename = $PROFILE.CurrentUserCurrentHost;
        }
    }
    $dir = Resolve-Path -Path "$filename/../"
    & "code" @($dir)
}

function Reload-Profile()
{
    Write-Host "Plase run the following line manually."
    Write-Host "`". `$PROFILE`""
}

function Test-Admin()
{
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    $principal = New-Object Security.Principal.WindowsIdentity $user;
    $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function RunAs-Admin()
{
    param
    (
        [Parameter(Mandatory, Position=0)]
        [string]$exe,

        [Parameter(Position=1)]
        [string[]]$exeArgs
    )
    # Windows doesn't support RunAs with -UseNewEnvironment:$false
    Start-Process `
        -Verb "RunAs" `
        -FilePath $exe `
        -ArgumentList @exeArgs `
        -WorkingDirectory $(Get-Location)
}

function Fork-Shell()
{
    Start-Process "pwsh.exe" @("-Interactive")
}

function Sudo-Shell()
{
    RunAs-Admin "pwsh.exe" @("-Interactive")
}

function List-Env()
{
    Get-ChildItem env:* | Sort-Object name
}

function Reload-Path()
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

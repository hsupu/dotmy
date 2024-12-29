
function global:UpgradePwsh {
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
}

function global:EditPwshProfile {
    param(
        [switch]$AllUser,
        [switch]$AllHost
    )

    if ($AllUser) {
        if ($AllHost) {
            $filename = $PROFILE.AllUsersAllHosts
        }
        else {
            $filename = $PROFILE.AllUsersCurrentHost
        }
    }
    else {
        if ($AllHost) {
            $filename = $PROFILE.CurrentUserAllHosts
        }
        else {
            $filename = $PROFILE.CurrentUserCurrentHost
        }
    }
    $dir = Resolve-Path -LiteralPath (Join-Path $filename "..")
    & "code" @($dir)
}

function global:ReloadPwshProfile {
    Write-Host "Limitation!!! Plase run the following line manually."
    Write-Host "`". `$PROFILE`""
}

# 重复了，但便于使用
function global:Test-Admin {
    param(
        [switch]$NoThrow
    )
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($currentUser)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin -and -not $NoThrow) {
        throw "Required to be run as Administrator"
    }
    return $isAdmin
}

function global:RunAsAdmin {
    param(
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

function global:Get-EnvPath {
    param(
        [switch]$NoSubstitute
    )
    if ($NoSubstitute) {
        Get-ItemPropertyValue -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path"
    }
}

function global:ReloadEnvPath {
    $machine = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine).Split([IO.Path]::PathSeparator)
    $user = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User).Split([IO.Path]::PathSeparator)
    $env:Path = [string]::Join([IO.Path]::PathSeparator, $machine + $user)
}

function global:ForkShell {
    Start-Process "pwsh.exe" @("-Interactive")
}

function global:ForkShellAdmin {
    Start-Process "pwsh.exe" @("-Interactive") -Verb "RunAs"
}

function global:ForkCmd {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$File,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Remaining
    )

    # Write-Host $Remaining
    # return

    $startTag = "ENVIRONMENT_VARIABLES_START"
    $tempFile = [IO.Path]::GetTempFileName()
    & "$env:Comspec" /c " ""$File"" $Remaining && echo $startTag > $tempFile && set >> $tempFile"

    $a = Get-Content -LiteralPath $tempFile -ErrorAction Stop
    $foundStart = $false
    $a.Split("`n") | ForEach-Object {
        $line = $_.Trim()
        if ((-not $foundStart) -and ($line -eq $startTag)) {
            $foundStart = $true
        }
        if ($foundStart -and $_ -match "^(.*?)=(.*)$") {
            Set-Item -LiteralPath env:$($MATCHES[1]) -Value $MATCHES[2]
        }
    }

    Remove-Item -LiteralPath $tempFile -ErrorAction Stop
}

function global:RunNested([string]$cmd) {
    $isPwsh = ([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("6.0")) -ge 0
    $exe = if ($isPwsh) { "pwsh.exe" } else { "powershell.exe" }
    $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($cmd))
    & $exe -NoProfile -ExecutionPolicy Bypass -EncodedCommand $base64
    if ($LASTEXITCODE -ne 0) {
        throw "$exe exited with code $LASTEXITCODE"
    }
}

function global:GetLastError {
    $_ | Format-List * -Force
}

<#
.DESCRIPTION
请先 scoop install nssm
#>
param(
    [string]$ServiceName,
    [string[]]$ExeArgs,
    [string]$WorkDir,
    [string]$LogToDir,
    [switch]$ManualStart,
    [switch]$RunAsLocalSystem,
    [scriptblock]$PostInstall,
    [switch]$StartNow,

    [switch]$ReinstallIfExist,
    [switch]$NoDumpIfExist
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Requires to run as Administrator"
}

Write-Output "nssm status $ServiceName"
$status = & nssm status $ServiceName
if (0 -eq $LASTEXITCODE) {
    Write-Output $status

    if (-not $NoDumpIfExist) {
        Write-Output "nssm dump $ServiceName"
        & nssm dump $ServiceName
        if (0 -ne $LASTEXITCODE) {
            throw "nssm dump exited with $LASTEXITCODE"
        }
    }

    if (-not $ReinstallIfExist) {
        Write-Output "$ServiceName is already installed"
        return
    }
    else {
        Write-Warning "Reinstalling $ServiceName"
    }

    if ($status -ne "SERVICE_STOPPED") {
        Write-Output "nssm stop $ServiceName"
        & nssm stop $ServiceName
        if (0 -ne $LASTEXITCODE) {
            throw "nssm stop exited with $LASTEXITCODE"
        }
    }

    # confirm : no confirm prompt
    Write-Output "nssm remove $ServiceName"
    & nssm remove $ServiceName confirm
    if ((0 -ne $LASTEXITCODE) -and (4 -ne $LASTEXITCODE)) {
        throw "nssm remove exited with $LASTEXITCODE"
    }

    $seconds = 1
    if ($seconds -gt 0) {
        Write-Output "Wait $($seconds)s"
        Start-Sleep -Seconds $seconds
    }
}
elseif (3 -ne $LASTEXITCODE) {
    throw "nssm status exited with $LASTEXITCODE"
}

# 这自动拆分 $ExeArgs 设置 nssm DisplayName AppParameters
Write-Output "nssm install $ServiceName $ExeArgs"
& nssm install $ServiceName @ExeArgs
if (0 -ne $LASTEXITCODE) {
    throw "nssm install exited with $LASTEXITCODE"
}

& nssm set $ServiceName AppDirectory $WorkDir

# nssm 只继承 Machine 环境变量，不继承 User 环境变量
$nssmEnvs = [System.Collections.Generic.Dictionary[string, string]]::new()
$nssmEnvs.Add("DOTMY", $env:DOTMY)
$nssmEnvs.Add("SCOOP", $env:SCOOP)
$nssmPath = [System.Collections.Generic.List[string]]::new()
$nssmPath += @(
    "C:\my\bin;C:\my\local\bin;C:\opt\scoop\shims",
    "$HOME\.dotnet\tools"
)
if (Test-Path env:JAVA_HOME) {
    $nssmEnvs.Add("JAVA_HOME", $env:JAVA_HOME)
    $nssmPath += @("C:\opt\scoop\apps\temurin21-jdk\current\bin")
}
if (Test-Path env:PYENV) {
    $nssmEnvs.Add("PYENV", $env:PYENV)
    $nssmPath += @("C:\opt\scoop\apps\pyenv\current\pyenv-win\bin;C:\opt\scoop\apps\pyenv\current\pyenv-win\shims")
}
if ((Test-Path env:NVM_HOME) -and (Test-Path env:NVM_SYMLINK)) {
    $nssmEnvs.Add("NVM_HOME", $env:NVM_HOME)
    $nssmEnvs.Add("NVM_SYMLINK", $env:NVM_SYMLINK)
    $nssmPath += @("$env:LOCALAPPDATA\pnpm")
}

# 或者设置 AppEnvironment 完全覆盖所有环境变量
& nssm set $ServiceName AppEnvironmentExtra ":PATH=$($nssmPath -join ";" -replace ";+", ";")"
foreach ($env in $nssmEnvs.GetEnumerator()) {
    & nssm set $ServiceName AppEnvironmentExtra "+$($env.Key)=$($env.Value)"
}

if ('' -ne [string]$LogToDir) {
    & nssm set $ServiceName AppStdout "$LogToDir\$ServiceName.stdout.log"
    & nssm set $ServiceName AppStderr "$LogToDir\$ServiceName.stderr.log"
}

& nssm set $ServiceName AppNoConsole 0

if ($ManualStart) {
    & nssm set $ServiceName Start SERVICE_DEMAND_START
}
else {
    & nssm set $ServiceName Start SERVICE_DELAYED_AUTO_START
}

# NT AUTHORITY\LocalService has minimum privileges
# NT AUTHORITY\LocalSystem has full control
# NT AUTHORITY\NetworkService is for service in an AD domain that needs machine's credentials
# if needed, create user with needed privileges and allow to "Log On As A Service" in Local Security Policy
if ($RunAsLocalSystem) {
    & nssm set $ServiceName ObjectName LocalSystem
}
else {
    & nssm set $ServiceName ObjectName LocalService
}

& nssm set $ServiceName Type SERVICE_WIN32_OWN_PROCESS
& nssm set $ServiceName AppPriority NORMAL_PRIORITY_CLASS
& nssm set $ServiceName AppAffinity All

# bit flags: 1=Ctrl-C, 2=WM_CLOSE, 4=WM_QUIT, 8=TerminateProcess()
& nssm set $ServiceName AppStopMethodSkip 0
& nssm set $ServiceName AppStopMethodConsole 1500
& nssm set $ServiceName AppStopMethodWindow 1500
& nssm set $ServiceName AppStopMethodThreads 1500

# 如果服务持续时间小于该值，则推迟下一次重启
& nssm set $ServiceName AppThrottle 1500
& nssm set $ServiceName AppExit Default Restart
& nssm set $ServiceName AppRestartDelay 1000

if ($PostInstall) {
    & $PostInstall
}

Write-Output "nssm dump $ServiceName"
& nssm dump $ServiceName
if (0 -ne $LASTEXITCODE) {
    throw "nssm dump exited with $LASTEXITCODE"
}

if ($StartNow) {
    Write-Output "nssm start $ServiceName"
    & nssm start $ServiceName
    if (0 -ne $LASTEXITCODE) {
        throw "nssm start exited with $LASTEXITCODE"
    }
}

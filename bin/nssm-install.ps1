<#
.DESCRIPTION
请先 scoop install nssm
#>
param(
    [string]$ServiceName,
    [string]$WorkDir,
    [string[]]$ExeArgs,
    [switch]$RunAsLocalSystem,
    [scriptblock]$PostInstall
)

$isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Requires to run as Administrator"
}

Write-Output "nssm status $ServiceName"
$status = & nssm status $ServiceName
if ($LASTEXITCODE -eq 0) {
    Write-Output $status

    if (-not $Reinstall) {
        Write-Output "$ServiceName is already installed"
        return
    }
    else {
        Write-Output "Reinstalling $ServiceName"
    }

    if ($status -ne "SERVICE_STOPPED") {
        Write-Output "nssm stop $ServiceName"
        & nssm stop $ServiceName
        if ($LASTEXITCODE -ne 0) {
            Write-Error -ErrorAction Stop "nssm stop exited with $LASTEXITCODE"
            throw
        }
    }

    if (-not $NoDump) {
        Write-Output "nssm dump $ServiceName"
        & nssm dump $ServiceName
        if ($LASTEXITCODE -ne 0) {
            Write-Error -ErrorAction Stop "nssm dump exited with $LASTEXITCODE"
            throw
        }
    }

    # confirm : no confirm prompt
    Write-Output "nssm remove $ServiceName"
    & nssm remove $ServiceName confirm
    if (($LASTEXITCODE -ne 0) -and ($LASTEXITCODE -ne 4)) {
        Write-Error -ErrorAction Stop "nssm remove exited with $LASTEXITCODE"
        throw
    }

    $seconds = 1
    if ($seconds -gt 0) {
        Write-Output "Wait $($seconds)s"
        Start-Sleep -Seconds $seconds
    }
}
elseif ($LASTEXITCODE -ne 3) {
    Write-Error -ErrorAction Stop "nssm status exited with $LASTEXITCODE"
    throw
}

Write-Output "nssm install $ServiceName"
& nssm install $ServiceName @ExeArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error -ErrorAction Stop "nssm install exited with $LASTEXITCODE"
    throw
}

& nssm set $ServiceName AppDirectory $WorkDir
# & nssm set $ServiceName AppEnvironmentExtra JAVA_HOME=C:\java
& nssm set $ServiceName AppNoConsole 0

& nssm set $ServiceName Start SERVICE_DELAYED_AUTO_START
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

if ($Start) {
    Write-Output "nssm start $ServiceName"
    & nssm start $ServiceName
    if ($LASTEXITCODE -ne 0) {
        Write-Error -ErrorAction Stop "nssm start exited with $LASTEXITCODE"
        throw
    }
}

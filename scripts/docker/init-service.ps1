
[CmdletBinding()]
param(
    [switch]$Stop,
    [switch]$Unregister,
    [switch]$InitUserGroup,
    [switch]$Register,
    [switch]$Start,
    [switch]$Wait,
    [switch]$Test
)

$script:DockerUserGroupName = "docker-users"
$script:DockerServiceName = "docker"
$script:DockerDataPath = "$($env:ProgramData)\docker"

function Test-Admin
{
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

function Test-DockerService
{
    param(
        [switch]$ExpectNonExist,
        [switch]$Wait
    )
    Write-Host "Checking service existence: $script:DockerServiceName expected=$(-not $ExpectNonExist) wait=$Wait"
    $ret = $false
    $startAt = Get-Date
    while (-not $ret) {
        $srv = Get-Service -ErrorAction SilentlyContinue -Name $script:DockerServiceName
        $ret = ($null -ne $srv) -xor $ExpectNonExist
        if ($ret -or -not $Wait) {
            break
        }
        Start-Sleep -Seconds 1
    }
    return $ret
}

function Test-DockerServiceStatus
{
    param(
        [string]$Expected,
        [switch]$Wait
    )
    Test-DockerService -Wait
    Write-Host "Checking service status: $script:DockerServiceName expected=$Expected wait=$Wait"
    $ret = $false
    $startAt = Get-Date
    while (-not $ret) {
        $srv = Get-Service -ErrorAction SilentlyContinue -Name $script:DockerServiceName
        $ret = ($Expected -ieq $srv.Status.ToString())
        if ($ret -or -not $Wait) {
            break
        }
        Start-Sleep -Seconds 1
    }
    return $ret
}

function Register-Service
{
    if (Test-DockerService) {
        Write-Host "service already existed: $script:DockerServiceName"
        return
    }

    $dockerdConfigPath = Join-Path $script:DockerDataPath "daemon.json"

    $exeArgs = @(
        "--validate",
        "--config-file", $dockerdConfigPath
    )
    Write-Host "Executing: dockerd $exeArgs"
    & dockerd @exeArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Error -ErrorAction Stop "dockerd exited with code $LASTEXITCODE"
    }

    $exeArgs = @(
        "--register-service", "--service-name", $script:DockerServiceName,
        "--config-file", $dockerdConfigPath
    )
    Write-Host "Executing: dockerd $exeArgs"
    & dockerd @exeArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Error -ErrorAction Stop "dockerd exited with code $LASTEXITCODE"
    }
}

function Unregister-Service
{
    if (Test-DockerService -ExpectNonExist) {
        Write-Host "service not existed: $script:DockerServiceName"
        return
    }

    # Remove-Service -ErrorAction Stop -Name $script:DockerServiceName
    $exeArgs = @(
        "--unregister-service", "--service-name", $script:DockerServiceName
    )
    Write-Host "Executing: dockerd $exeArgs"
    & dockerd @exeArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Error -ErrorAction Stop "dockerd exited with code $LASTEXITCODE"
    }
}

function Test-DockerConnection
{
    param(
        [switch]$Wait
    )
    $ret = $false
    $startAt = Get-Date
    while (-not $ret) {
        & docker version | Out-Null
        $ret = $LASTEXITCODE -eq 0
        if ($ret -or -not $Wait) {
            break
        }
        Start-Sleep -Seconds 1
    }
    return $ret
}

function main
{
    Test-Admin | Out-Null

    try {

        if ($script:Stop) {
            Stop-Service -ErrorAction Stop -Name $script:DockerServiceName
            if ($script:Wait) {
                Test-DockerServiceStatus -Expected "Stopped" -Wait
            }
        }

        if ($script:Unregister) {
            Unregister-Service
            if ($script:Wait) {
                Test-DockerService -ExpectNonExist -Wait
            }
        }

        if ($script:InitUserGroup) {
            $group = Get-LocalGroup -ErrorAction SilentlyContinue -Name $script:DockerUserGroupName
            if ($null -eq $group) {
                $group = New-LocalGroup -Name $script:DockerUserGroupName
                # if ($null -eq $group) {
                #     $group = Get-LocalGroup -ErrorAction Stop -Name $script:DockerUserGroupName
                # }
            }
            $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
            # & net localgroup $script:DockerUserGroupName $currentUser.Name /add
            if (-not (Get-LocalGroupMember -ErrorAction SilentlyContinue -Group $script:DockerUserGroupName -Member $currentUser.User)) {
                Add-LocalGroupMember -ErrorAction Stop -Group $script:DockerUserGroupName -Member $currentUser.User
                Write-Output "Requires sign-out and sign-in to take effect."
            }
        }

        if ($script:Register) {
            Register-Service
            if ($script:Wait) {
                Test-DockerService -Wait
            }
        }

        if ($script:Start) {
            Start-Service -ErrorAction Stop -Name $script:DockerServiceName
            if ($script:Wait) {
                Test-DockerServiceStatus -Expected "Running" -Wait
            }
        }

        if ($script:Test) {
            Test-DockerConnection -Wait:$script:Wait
        }

    }
    catch {
        Write-Error -ErrorAction Stop "$($_.ToString())`n$($_.ScriptStackTrace)"
    }
}

main

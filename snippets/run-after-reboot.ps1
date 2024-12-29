<#
.LINK
https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1
#>
[CmdletBinding()]
param(
    [string]$NextScriptPath,
    [string]$NextScriptArgs,
    [switch]$RebootIfNeeded,
    [switch]$ForceRebootIfNeeded
)

$script:RebootScriptsDir = "$($env:LocalAppData)\RebootScripts"
$script:RebootScriptName = "post-install-features-for-docker.ps1"
$script:ScheduledTaskName = "PostInstallFeaturesForDocker"

$global:RebootRequired = $false

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

function Add-ContinueTask
{
    # $scriptArgs = $script:MyInvocation.Line.Substring($script:MyInvocation.OffsetInLine - 1 + $script:MyInvocation.InvocationName.Length)
    # $scriptPath = $script:MyInvocation.MyCommand.Path
    $scriptPath = Resolve-Path -ErrorAction Stop -LiteralPath $script:NextScriptPath

    if (-not (Test-Path $script:RebootScriptsDir -PathType Container)) {
        New-Item -ErrorAction Stop -LiteralPath $script:RebootScriptsDir -ItemType Directory | Out-Null
    }
    $rerunPath = Join-Path $script:RebootScriptsDir $script:RebootScriptName
    Copy-Item -ErrorAction Stop -Path $scriptPath -Destination $rerunPath -Force

    Write-Host "Creating scheduled task..."
    $action = New-ScheduledTaskAction -ErrorAction Stop -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy RemoteSigned -File `"$rerunPath`" $script:NextScriptArgs"

    Write-Host "Creating task trigger..."
    $trigger = New-ScheduledTaskTrigger -ErrorAction Stop -AtLogOn

    Write-Host "Binding task to trigger..."
    $task = Register-ScheduledTask -ErrorAction Stop -TaskName $script:ScheduledTaskName -Action $action -Trigger $trigger -RunLevel Highest
}

function Remove-ContinueTask
{
    $task = Get-ScheduledTask -ErrorAction SilentlyContinue -TaskName $script:ScheduledTaskName
    if ($null -eq $task) {
        return
    }
    $task | Unregister-ScheduledTask -ErrorAction Stop -Confirm:$false
}

function main
{
    Test-Admin

    try {
        if ($global:RebootRequired -and ('' -ne $script:RebootScriptName)) {
            Add-ContinueTask

            if (-not $script:RebootIfNeeded) {
                Write-Host "Please reboot the machine manually to complete the installation."
                return
            }
            else {
                Restart-Computer -ErrorAction Stop -Force:$script:ForceRebootIfNeeded

                Write-Host "Waiting for reboot..."
                while ($true) {
                    Start-Sleep -Seconds 1
                }
            }
        }
    }
    catch {
        Write-Error -ErrorAction Stop "$($_.ToString())`n$($_.ScriptStackTrace)"
    }
}

main

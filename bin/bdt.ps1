<#
.SYNOPSIS
detach and build

.PARAMETER NoInvokeBuild
if not, run "b.ps1"

.PARAMETER MSBuild
if not -NoInvokeBuild. try "build" or "msbuild" instead of "b.ps1".

.PARAMETER WaitChanges
if enabled, wait for newer CommitId if HEAD == CommitId on start

.NOTES
这里将 $Remaining 拆分为 NewBoundParams NewUnboundParams 也许只是炫技，但调用其他 ps1 也许必须如此。

#>
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position=0)]
    [string]$CommitId,

    [switch]$NoInvokeBuild,
    [switch]$WaitChanges,
    [switch]$MSBuild,

    [Parameter(ValueFromRemainingArguments)]
    [AllowEmptyCollection()]
    $Remaining
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

if ([string]::IsNullOrEmpty($CommitId)) {
    Write-Error "No -CommitId"
    exit(1)
}

while ($true)
{
    $shaHead = $(git rev-parse HEAD)
    $shaCommitId = $(git rev-parse $CommitId)

    if ($shaHead -ne $shaCommitId) {
        break
    }

    if (-not $WaitChanges) {
        break
    }
    Write-Host "No change, sleep 1s at $(Get-Date -Format 'yyMMdd HHmmss')"
    Start-Sleep -Seconds 1
}

if ($shaHead -ne $shaCommitId) {
    # "--" to distinguish options and path
    & git checkout --detach $shaCommitId --
    if (0 -ne $LASTEXITCODE) {
        Write-Error "git checkout exited with code $LASTEXITCODE"
        return $LASTEXITCODE
    }
}

if ($NoInvokeBuild) {
    return
}

function which($s) {
    try {
        $cmd = Get-Command $s -ErrorAction SilentlyContinue
        return $cmd.Definition
    }
    catch {
        # Write-Error $_
        return $null
    }
}

if ($MSBuild) {
    $cmd = which("build")
    if ($null -ne $cmd) {
        & build @Remaining
        return
    }

    $cmd = which("msbuild")
    if ($null -ne $cmd) {
        & msbuild @Remaining
        return
    }

    Write-Error "msbuild not found"
    return
}

$NewBoundParams = @{}
$NewUnboundParams = @()

$CurParamName = $null
foreach ($p in $Remaining)
{
    if ($p.StartsWith('-')) {
        if (-not $p.StartsWith('--')) {
            $CurParamName = $p.Substring(1)
            $NewBoundParams[$CurParamName] = $True
        }
        else {
            $NewUnboundParams += $p
            $CurParamName = $null
        }
    }
    elseif ($null -ne $CurParamName) {
        $NewBoundParams[$CurParamName] = $p
        $CurParamName = $null
    }
    else {
        $NewUnboundParams += $p
        $CurParamName = $null
    }
}

& b.ps1 @NewBoundParams @NewUnboundParams

param(
    [string]$NoFwdStr,
    [switch]$NoFwdBool,

    [Parameter(ValueFromRemainingArguments)]
    [AllowEmptyCollection()]
    [object[]]$Params # = $null
)

$ErrorActionPreference = 'Stop'
trap { throw $Error[0]; }

Write-Host ($PSBoundParameters | Out-String)
Write-Host "unbound: $Params"
Write-Host "unbound: $args"

$NewBoundParams = @{}
$NewUnboundParams = @()

$CurParamName = $null
foreach ($p in $Params)
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
    elseif ($CurParamName -ne $null) {
        $NewBoundParams[$CurParamName] = $p
        $CurParamName = $null
    }
    else {
        $NewUnboundParams += $p
        $CurParamName = $null
    }
}

Write-Host ($NewBoundParams | Out-String)
Write-Host "unbound: $NewUnboundParams"
exit(0)

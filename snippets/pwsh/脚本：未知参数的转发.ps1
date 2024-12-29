[CmdletBinding()]
param(
    [string]$OptString,
    [switch]$Flag

    # [Parameter(ValueFromRemainingArguments)]
    # [AllowEmptyCollection()]
    # [object[]]$Params # = $null
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

Write-Host "Bound"
Write-Host ($PSBoundParameters | Format-Table -HideTableHeaders | Out-String)
# Write-Host "NonBound `$Params"
# Write-Host ($Params | Format-List)
Write-Host "NonBound `$args" # should be $null since ValueFromRemainingArguments is used
Write-Host ($args | Format-List | Out-String)

$NewBoundParams = @{}
$NewNonBoundParams = @()

$CurParamName = $null
foreach ($p in $Params)
{
    if ($p.StartsWith('-')) {
        if (-not $p.StartsWith('--')) {
            $CurParamName = $p.Substring(1)
            $NewBoundParams[$CurParamName] = $True
        }
        else {
            $NewNonBoundParams += $p
            $CurParamName = $null
        }
    }
    elseif ($CurParamName -ne $null) {
        $NewBoundParams[$CurParamName] = $p
        $CurParamName = $null
    }
    else {
        $NewNonBoundParams += $p
        $CurParamName = $null
    }
}

Write-Host "Updated Bound"
Write-Host ($NewBoundParams | Out-String)
Write-Host "Updated NonBound"
Write-Host ($NewNonBoundParams | Format-List | Out-String)


function Remove-ComObject {
    # Requires -Version 2.0
    [CmdletBinding()]
    param()
    end {
        Start-Sleep -Milliseconds 500
        [Management.Automation.ScopedItemOptions]$scopedOpt = 'ReadOnly, Constant'
        Get-Variable -Scope 1 | Where-Object {
            $_.Value.pstypenames -contains 'System.__ComObject' -and -not ($scopedOpt -band $_.Options)
        } | Remove-Variable -Scope 1 -Verbose:([bool]$PSBoundParameters['Verbose'].IsPresent)
        [gc]::Collect()
    }
}

$xl= New-Object -COM Excel.Application
$xl.Visible = $true
$xl.DisplayAlerts = $False
$xl.Workbooks.Open("C:\Scripts\PowerShell\test.xls")

$xl.quit()

Remove-ComObject -Verbose
# [System.Runtime.InteropServices.Marshal]::ReleaseComObject($xl)

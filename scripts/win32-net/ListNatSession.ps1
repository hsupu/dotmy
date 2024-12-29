<#
.NOTES
WinNat 置于 PID=4 System 进程中。
#>
Get-NetNatSession | Group-Object -Property Protocol -NoElement

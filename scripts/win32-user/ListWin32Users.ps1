
Write-Host "Local Users and Groups"
Get-WmiObject -class "win32_account" -namespace "root\cimv2" | sort caption | format-table caption, __CLASS, SID

Write-Host "NT Services"


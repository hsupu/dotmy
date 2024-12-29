<#
.NOTES
reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\AutoAttachVirtualDisks /s

#>
param()

$regKey = 'HKLM:\SYSTEM\ControlSet001\Control\AutoAttachVirtualDisks'
"Listing $regKey"

$regKeys = Get-ChildItem -LiteralPath $regKey

$regKeys | % {
    $path = $_.GetValue('Path')
    $basename = [System.IO.Path]::GetFileName($_.Name)
    "$basename = $path"
}

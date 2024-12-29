<#
.NOTES
自动挂载是 mountmgr 服务管理的。
#>
param()

& reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\mountmgr" /s

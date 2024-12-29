<#
.NOTES
简单函数有两个行为：启用位置绑定，绑定剩下的置于 $args 中。
高级函数没有 $args。

241111 puxu: 这什么意思？
无法禁用简单函数的位置绑定，这可能导致赋值错位，如 "/?" 绑定到 [string] 参数中。

.LINK
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions?view=powershell-7.3#positional-parameters

#>
param(
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

"NonBound `$args"
$args | Format-List

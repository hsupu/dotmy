<#
.NOTES
高级函数可以禁用位置绑定，但没有 $args，需要使用 ValueFromRemainingArguments 具名参数替代。
CmdletBinding 即启用高级函数。

使用具名未绑定参数后，$args 会被清空。

.EXAMPLE
命令行参数
    -NotExist a --b c d

绑定情况
    OptString = "--b"
    Flag = $false
    Params = {"-NotExist", "a", "c", "d"}
    args 未定义

.LINK
CmdletBinding and Advanced Functions
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced?view=powershell-7.3

PositionalBinding
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#position-argument

ValueFromRemainingArguments
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3#valuefromremainingarguments-argument

#>
[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter()]
    [string]$OptString,

    [switch]$Flag,

    [Parameter(ValueFromRemainingArguments)]
    [AllowEmptyCollection()]
    $Params # = $null
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

"Bound"
$PSBoundParameters.GetEnumerator() | ForEach-Object { $_.Key + " : " + $_.Value.GetType() + " = " + ($_.Value | ForEach-Object { "`"$_`"" }) }
""

"NonBound `$Params"
$Params | Format-List
""

"NonBound `$args"
$args | Format-List

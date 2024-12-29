
## PowerShell 输出

https://devblogs.microsoft.com/powershell/how-powershell-formatting-and-outputting-really-works/

### `Out-*`

如果语句、管道的最后没有显式调用 `Out-*`，PowerShell 会自动追加 `Out-Default`。
`<expression>` 会被拓展为 `<expression> | Out-Default`。
`<exp1>; <exp2>` 会被拓展为 `<exp1> | Out-Default; <exp2> | Out-Default`。即每“行”都自带输出。

最外层的 `Out-Default` 会 `Out-Host`。当某处重定向或者构建了管道。则其内所有层次的 `Out-Default` 都被重定向。

如果不想输出，用 `<exp> | Out-Null`。
显然，除了 `Out-Default`，其余的 `Out-*` 都经常明写，以显式控制输出。

`Out-*` 有：

- `Microsoft.PowerShell.Core` module: `Out-Default` `Out-Host` `Out-Null`
- `Microsoft.PowerShell.Utility` module: `Out-File` `Out-GridView` `Out-Printer` `Out-String`

`>` 一般可视为 `Out-File` 的别名。参见 https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection

`Out-Default` 会根据类型注册的视图类型（有 wide list table custom 四种）调用对应的 `Format-*`，根据 `Format.ps1xml` 来控制格式化输出。参见 cmdlet `Update-FormatData`。

### `Write-*`

`$o | Write-Output` 等价于 `$o`。别忘了隐式追加 `Out-Default`。

`$o | Write-Output -NoEnumerate` 不一定等价于 `Write-Output -NoEnumerate $o`。`Write-Output -NoEnumerate` 会把 `$o` 作为一个整体输出，但管道操作在遇到可枚举类型时，会枚举其元素。

`Write-*` 有

- `Microsoft.PowerShell.Utility` module: `Write-Debug` `Write-Error` `Write-Host` `Write-Information` `Write-Output` `Write-Progress` `Write-Verbose` `Write-Warning`

除了 `Write-Host` 是 `Write-Information` 的包装外，其他都是不同的输出流。参见 https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_output_streams

## PowerShell 常用语法与其它语言中惯用法的区别



`return <expression>` 等价于 `<expression>; return`。

## 调试信息

```ps1

```

## 脚本技巧：可执行的函数脚本

```ps1
$cmdstr = $MyInvocation.Line.Substring($MyInvocation.OffsetInLine - 1)
if (-not ($cmdstr.StartsWith(". "))) {
    # direct run - local test
    Write-Host $cmdstr
}
```

## 二进制流的传递

方法：使用 `System.IO.Steram` 中转，参见 `cmdlet\convert-stream.ps1`。

问题：`return byte[]` 会被 PowerShell enumerate，产生 `object[]` 而不是保留 `byte[]`。

https://stackoverflow.com/questions/61439620/how-can-i-return-a-byte-array-rather-than-an-object-array-from-a-powershell-fu

方法：再套一层 enumerable，如 `return @(byte[])` `return , $bytes`。

方法：使用 `Write-Output -NoEnumerate $array`。

拓展：我是从这个网页进来的，研究一下是否有保留的必要，是否有更多内容。
https://www.renenyffenegger.ch/notes/Windows/PowerShell/language/type/array/byte/index#:~:text=Github%20respository%20about-PowerShell%2C%20path%3A%20%2Flanguage%2Ftype%2Farray%2Fbyte%2Freturn-in-function%2Fnaive.ps1%20When%20executed%2C%20this,byteArray%3A%20System.Byte%20%5B%5D%20type%20of%20x%3A%20System.Object%20%5B%5D

## 异常处理

<#
.EXAMPLE
Using-Culture "ar-IQ" { Get-Date }

.LINK
https://devblogs.microsoft.com/powershell/using-culture-culture-culture-script-scriptblock/
#>
param(
    [System.Globalization.CultureInfo]$Culture = (throw "USAGE: Using-Culture -Culture culture -Script {scriptblock}"),
    [ScriptBlock]$Script = (throw "USAGE: Using-Culture -Culture culture -Script {scriptblock}")
)

$OldCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
trap {
    [System.Threading.Thread]::CurrentThread.CurrentCulture = $OldCulture
}
[System.Threading.Thread]::CurrentThread.CurrentCulture = $Culture
Invoke-Command $Script
[System.Threading.Thread]::CurrentThread.CurrentCulture = $OldCulture

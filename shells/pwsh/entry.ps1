param()

# https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/set-strictmode?view=powershell-7.4
#
# Off
#   根据类型，未初始化的变量值为 0 or $null
#   引用不存在的属性，返回 $null
#   下标越界或下标类型不匹配，返回 $null
#
# 1.0
#   引用不存在的变量，报错
#
# 2.0
#   使用方法语法调用 PowerShell 函数，报错
#      function foo($a) {}
#      foo(1)       # ERR, 曾被视为 $a = @(1)
#      foo -a 1     # OK
#
#   引用未初始化的变量，报错
#   引用不存在的属性，报错
#
# 3.0
#   下标越界或下标类型不匹配，报错
#
Set-StrictMode -Version 1.0

# see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.1#erroractionpreference
$ErrorActionPreference = 'Stop'
# $WarningPreference = 'Continue'
# $ProgressPreference = 'SilentlyContinue'
# $InformationPreference = 'Continue'
# $VerbosePreference = 'Continue'
# $DebugPreference = 'Break'

# since 7.3, enabled by default. see: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.3#psnativecommanduseerroractionpreference
$PSNativeCommandUseErrorActionPreference = $false

# see: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_trap?view=powershell-7.3
# trap { throw $_ }

$isPwsh = ([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("6.0")) -ge 0

# Specify cmdlets
# see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.1#psdefaultparametervalues
# $PSDefaultParameterValues['*:ErrorAction'] = 'Stop'
# $PSDefaultParameterValues += @{
#     "Get-Function:ErrorAction" = "Stop"
#     "Get-Command:ErrorAction" = "Stop"
#     "Get-MyFunction*:ErrorAction" = "Stop"
# }

function Set-PowerShellSessionLanguage {
    Param (
        [Parameter(Mandatory)]
        [System.Globalization.CultureInfo] $CultureInfo,

        [switch] $CheckLangPack,
        [switch] $SetCulture,
        [switch] $SetUICulture
    )

    if ($CheckLangPack) {
        if ($CultureInfo -notin (Get-WinUserLanguageList | % { $_.LanguageTag })) {
            throw "Language pack for $CultureInfo is not installed."
        }
    }

    if ($SetCulture) {
        [Globalization.CultureInfo]::CurrentCulture = $CultureInfo
    }
    if ($SetUICulture) {
        [Globalization.CultureInfo]::CurrentUICulture = $CultureInfo
    }

    # https://stackoverflow.com/questions/62872708/fully-change-language-including-culture-for-the-current-powershell-session
    if (-not $isPwsh) {
        if ($SetCulture) {
            [System.Reflection.Assembly]::Load('System.Management.Automation').GetType('Microsoft.PowerShell.NativeCultureResolver').GetField('m_Culture', 'NonPublic, Static').SetValue($null, $CultureInfo)
        }
        if ($SetUICulture) {
            [System.Reflection.Assembly]::Load('System.Management.Automation').GetType('Microsoft.PowerShell.NativeCultureResolver').GetField('m_uiCulture', 'NonPublic, Static').SetValue($null, $CultureInfo)
        }
    }
}

Set-PowerShellSessionLanguage ([Globalization.CultureInfo]::GetCultureInfo("en-US")) -SetUICulture

$myCulture = [Globalization.CultureInfo]::CreateSpecificCulture("en-CN")
# $myCulture.DateTimeFormat.DateSeparator = "/"
# $myCulture.DateTimeFormat.TimeSeparator = ":"
$myCulture.DateTimeFormat.LongDatePattern = "yyyy/MM/dd"
$myCulture.DateTimeFormat.LongTimePattern = "hh:mm:ss"
# $myCulture.DateTimeFormat.FullDateTimePattern = "$($myCulture.DateTimeFormat.LongDatePattern) $($myCulture.DateTimeFormat.LongTimePattern)"
$myCulture.DateTimeFormat.ShortDatePattern = "yyyy/MM/dd"
$myCulture.DateTimeFormat.ShortTimePattern = "hh:mm"
# $myCulture.DateTimeFormat.YearMonthPattern = "MMMM yyyy"
# $myCulture.DateTimeFormat.MonthDayPattern = "MMMM d"
# $myCulture.DateTimeFormat.AMDesignator = "AM"
# $myCulture.DateTimeFormat.PMDesignator = "PM"
Set-PowerShellSessionLanguage $myCulture -SetCulture

if ([console]::InputEncoding.CodePage -ne 65001) {
    Write-Warning "pwsh input encoding is $([console]::InputEncoding)"
}
if ([console]::OutputEncoding.CodePage -ne 65001) {
    Write-Warning "pwsh output encoding is $([console]::OutputEncoding), force to use UTF-8 instead"
    # [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    # see: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.3#outputencoding
    $OutputEncoding = [System.Text.Encoding]::UTF8
}

# [Enum]::GetValues('ConsoleColor') | ForEach-Object { Write-Host $_ -ForegroundColor $_ }
# $Host.PrivateData.DebugForegroundColor = [ConsoleColor]::Black

# PowerShell Gallery rejects TLS < 1.2 since 2020-04, we force to use TLS 1.2 here
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Import-Module PSProfiler

&{
    $srcs = @(
        "$PSScriptRoot\env-vars.ps1",
        # "$PSScriptRoot\funcs\*.ps1",
        "$PSScriptRoot\cmdlets\*.ps1",
        "$PSScriptRoot\mod\*.ps1",
        "$PSScriptRoot\completers\*.ps1", # postponed to make it work for aliases
        "$env:DOTMY\local\pwsh-entry.ps1"
    )

    foreach ($src in $srcs) {
        $files = @(Get-ChildItem -ErrorAction SilentlyContinue -Path $src)
        if (0 -eq $files.Count) { continue }

        foreach ($file in $files) {
            if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { continue }
            Write-Information "sourcing $file"

            if ((Test-Path env:DEBUG_PWSH_PROFILE_LOADING) -and ('' -ne [string]$env:DEBUG_PWSH_PROFILE_LOADING)) {
                Write-Host -NoNewLine "Loading $file"
                $time = Measure-Command { . $file }
                Write-Host " in $($time.TotalSeconds)s"
            }
            else {
                & $file
            }
        }
    }
}

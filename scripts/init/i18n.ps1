param(
    [switch]$Set
)

$langs = Get-WinUserLanguageList | ForEach-Object { $_.LanguageTag }
if ($langs -notcontains "en-US") {
    Install-Language "en-US" -ExcludeFeatures
}
if ($langs -notcontains "zh-Hans-CN") {
    Install-Language "zh-Hans-CN" -CopyToSettings
}

# Set-WinUserLanguageList @("zh-Hans-CN")
$langs = New-WinUserLanguageList "en-US"
$langs.Add("zh-Hans-CN")
$langs[0].InputMethodTips.Clear()
$langs[1].InputMethodTips.Add("0409:00000409") # English - US
$langs[0].Handwriting = $false
$langs[1].InputMethodTips.Clear()
$langs[1].InputMethodTips.Add("0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7}") # Chinese
Set-WinUserLanguageList $langs

# IsLegacyLanguageBar - 是否使用传统的、桌面语言栏
# IsLegacySwitchingMode - 切换输入法将应用到全部程序，而不是传统的、每个程序拥有单独状态
$imeBarOpts = Get-WinLanguageBarOption
$imeBarOpts
Set-WinLanguageBarOption -UseLegacyLanguageBar:$false -UseLegacySwitchMode:$false

# clear override if have
$defaultImeOverride = Get-WinDefaultInputMethodOverride
if ($null -ne $defaultImeOverride) {
    $defaultImeOverride
    Set-WinDefaultInputMethodOverride
}

# clear override if have
$uiLangOverride = Get-WinUILanguageOverride
if ($null -ne $uiLangOverride) {
    $uiLangOverride
    Set-WinUILanguageOverride
}

$uiLang = Get-SystemPreferredUILanguage
if ($uiLang -ne "zh-Hans-CN") {
    $uiLang
    Set-SystemPreferredUILanguage "zh-Hans-CN"
}

$geo = Get-WinHomeLocation
if ($geo.GeoId -ne 0x68) {
    $geo
    # 0x2D (45) - CN, 0x68 (104) - HK, 0xF4 (244) - US
    Set-WinHomeLocation -GeoId 0x68
}

$tz = Get-TimeZone
if ($tz.Id -ne "China Standard Time") {
    $tz
    Set-TimeZone -Id "China Standard Time"
}

$globalCulture = Get-WinSystemLocale
if ($globalCulture.Name -ne "zh-CN") {
    $globalCulture
    Set-WinSystemLocale "zh-CN"
}

$useCustomCulture = Get-WinCultureFromLanguageListOptOut
if (-not $useCustomCulture) {
    $useCustomCulture
    Set-WinCultureFromLanguageListOptOut -OptOut $True
}

# HKCU:\Control Panel\International xxx
$userCulture = Get-Culture
if ($userCulture.Name -ne "zh-CN") {
    # $cultureName = 'zh-CN-my'
    # $cultureBuilder = [System.Globalization.CultureAndRegionInfoBuilder]::new($cultureName, [System.Globalization.CultureAndRegionModifiers]::None)
    # $baseCulture = [CultureInfo]::GetCultureInfo('en-US')
    # $baseRegion = [System.Globalization.RegionInfo]::new('CN')
    # $cultureBuilder.LoadDataFromCultureInfo($baseCulture)
    # $cultureBuilder.LoadDataFromRegionInfo($baseRegion)
    # foreach ($key in $overrides.Keys){
    #     $cultureBuilder.$key = $overrides[$key]
    # }
    # $cultureBuilder.Register()
    # [System.Globalization.CultureAndRegionInfoBuilder]::Unregister($cultureName)

    # $userCulture = [Globalization.CultureInfo]::new("zh-CN", $false)
    # $userCulture.DateTimeFormat.DateSeparator = "/"
    # $userCulture.DateTimeFormat.TimeSeparator = ":"
    # $userCulture.DateTimeFormat.LongDatePattern = "yyyy/MM/dd"
    # $userCulture.DateTimeFormat.LongTimePattern = "hh:mm:ss"
    # $userCulture.DateTimeFormat.FullDateTimePattern = "$($userCulture.DateTimeFormat.LongDatePattern) $($userCulture.DateTimeFormat.LongTimePattern)"
    # $userCulture.DateTimeFormat.ShortDatePattern = "yyyy/MM/dd"
    # $userCulture.DateTimeFormat.ShortTimePattern = "h:mm:ss"
    # $userCulture.DateTimeFormat.YearMonthPattern = "yyyy/M"
    # $userCulture.DateTimeFormat.MonthDayPattern = "M/d"
    # $userCulture.DateTimeFormat.AMDesignator = "AM"
    # $userCulture.DateTimeFormat.PMDesignator = "PM"
    # $userCulture.DateTimeFormat.FirstDayOfWeek = "Monday"
    # Set-Culture -ErrorAction Stop $userCulture
    # [Globalization.CultureInfo]::CurrentCulture = $userCulture
}
[Globalization.CultureInfo]::CurrentUICulture = [Globalization.CultureInfo]::GetCultureInfo("en-US")

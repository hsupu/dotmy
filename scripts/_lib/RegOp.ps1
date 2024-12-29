
function GetSetRegValue {
    param(
        [string]$key,
        [string]$name,
        [object]$value,
        [string]$type,
        [switch]$expectExisting
    )
    $isKeyExisted = Test-Path -LiteralPath $key -PathType Container
    if (-not $isKeyExisted) {
        New-Item -ErrorAction Stop -Path $key -ItemType Directory | Out-Null
    }

    $existingValue = Get-ItemPropertyValue -ErrorAction SilentlyContinue -Path $key -Name $name
    $isValueExisted = $null -ne $existingValue
    if (-not $isValueExisted -and $expectExisting) {
        throw "Unexpected not found: '$key' '$name'"
    }
    elseif ($isValueExisted) {
        # TODO check type
        Set-ItemProperty -ErrorAction Stop -Path $key -Name $name -Value $value
    }
    else {
        New-ItemProperty -ErrorAction Stop -Path $key -Name $name -Value $value -PropertyType $type
    }
}

function RegPathWCV {
    param(
        [string]$Suffix,
        [switch]$HKCU,
        [switch]$WindowsNT
    )
    if ($HKCU) {
        $Path0 = "HKCU:"
    }
    else {
        $Path0 = "HKLM:"
    }
    $Path1 = "SOFTWARE\Microsoft"
    if ($WindowsNT) {
        $Path2 = "Windows NT"
    }
    else {
        $Path2 = "Windows"
    }
    return "$Path0\$Path1\$Path2\CurrentVersion\$Suffix"
}

function RegPathPolicy {
    param(
        [string]$Suffix,
        [switch]$HKCU,
        [switch]$Wow6432Node,
        [switch]$CurrentVersion,
        [switch]$NoWindows
    )
    if ($HKCU) {
        $Path0 = "HKCU:"
    }
    else {
        $Path0 = "HKLM:"
    }
    if ($Wow6432Node) {
        $Path1 = "SOFTWARE\Wow6432Node"
    }
    else {
        $Path1 = "SOFTWARE"
    }
    if ($CurrentVersion) {
        $Path2 = "Microsoft\Windows\CurrentVersion\Policies"
    }
    elseif ($NoWindows) {
        $Path2 = "Policies\Microsoft"
    }
    else {
        $Path2 = "Policies\Microsoft\Windows"
    }
    return "$Path0\$Path1\$Path2\$Suffix"
}

function RegPathSrv {
    param(
        [string]$ServiceName
    )
    return "HKLM:\SYSTEM\CurrentControlSet\Services\$ServiceName\Parameters"
}

$hklmCmd = "HKLM:\Software\Microsoft\Command Processor"

$hklmWCV = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion"
$hklmWCVAppModelUnlock = RegPathWCV "AppModelUnlock"
$hklmWCVExplorerAdvanced = RegPathWCV "Explorer\Advanced"
$hklmWCVWindowsSearch = RegPathWCV "Windows\Windows Search"

$hklmPoliciesAdvertisingInfo = RegPathPolicy "AdvertisingInfo"
$hklmPoliciesAppCompat = RegPathPolicy "AppCompat"
$hklmPoliciesCloudContent = RegPathPolicy "CloudContent"
$hklmPoliciesDataCollection = RegPathPolicy "DataCollection"
$hklmPoliciesExplorer = RegPathPolicy "Explorer"
$hklmPoliciesSQMClientWindows = RegPathPolicy "SQMClient\Windows" -NoWindows
$hklmPoliciesWindowsChat = RegPathPolicy "Windows Chat"
$hklmPoliciesWindowsFeeds = RegPathPolicy "Windows Feeds"
$hklmPoliciesWindowsSearch = RegPathPolicy "Windows Search"

$hklmTermService = RegPathSrv "TermService"

$hklmFileSystem = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"

$hklmWCVPoliciesDataCollection = RegPathPolicy "DataCollection" -CurrentVersion

$hklmWow6432WCVPoliciesDataCollection = RegPathPolicy "DataCollection" -CurrentVersion -Wow6432Node

$hklmPolicyManagerDefault = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default"

$hkcuCmd = "HKCU:\Software\Microsoft\Command Processor"
$hkcuWCVExplorer = RegPathWCV -HKCU "Explorer"
$hkcuWCVExplorerAdvanced = RegPathWCV -HKCU "Explorer\Advanced"
$hkcuWCVFeeds = RegPathWCV -HKCU "Feeds"
$hkcuWCVSearch = RegPathWCV -HKCU "Search"
$hkcuWCVStart = RegPathWCV -HKCU "Start"

$hkcuWCVSearchSettings = RegPathWCV -HKCU "SearchSettings"
$hkcuWCVWinLogon = RegPathWCV -HKCU -WindowsNT "WinLogon"

$hkcuPoliciesDsh = RegPathPolicy -HKCU -NoWindows "Dsh"

$hkcuPoliciesExplorer = RegPathPolicy -HKCU "Explorer"

$hkcuWCVContentDeliveryManager = RegPathWCV -HKCU "ContentDeliveryManager"
$hkcuWCVPoliciesExplorer = RegPathPolicy -HKCU -CurrentVersion "Explorer"

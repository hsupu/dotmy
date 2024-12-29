
<#
.SYNOPSIS
在注册表（项、键、值）中搜索特定子串

.DESCRIPTION

.NOTES
项 key
键 entry
值 value

.LINK
https://docs.microsoft.com/en-us/powershell/scripting/samples/working-with-registry-entries?view=powershell-7.2
https://docs.microsoft.com/en-us/powershell/scripting/samples/working-with-registry-keys?view=powershell-7.2

#>
param(
    [Parameter(Mandatory)]
    [string]$Find,

    [Parameter()]
    [string]$Root,

    [Parameter()]
    [string]$OutFile,

    [switch]$MatchKeyName,
    [switch]$MatchKeyPath,
    [switch]$MatchEntryName,
    [switch]$MatchEntryValue,
    [switch]$DryRun
)

$ErrorActionPreference = 'Continue'
trap { throw $_ }

$script:Find = $script:Find.Trim().ToLower()
if ([string]::IsNullOrEmpty($script:Find)) {
    Write-Error "Empty -Find"
    return
}

if ([string]::IsNullOrEmpty($script:Root)) {
    $script:Root = "HKLM"
}

if ([string]::IsNullOrEmpty($script:OutFile)) {
    $script:OutFile = "immediate.txt"
}

if (-not $MatchKeyName -and -not $MatchKeyPath -and -not $MatchEntryName -and -not $MatchEntryValue) {
    Write-Error -ErrorAction Stop "No -Match* specified"
}

$foundKeys = [System.Collections.Generic.List[string]]::new()
$foundEntryNames = [System.Collections.Generic.List[string]]::new()
$foundEntryValues = [System.Collections.Generic.List[string]]::new()

function IsMatch($haystack, $needle) {
    # if ($haystack -eq $null) {
    #     Write-Host "null haystack"
    # }
    # if ($needle -eq $null) {
    #     Write-Host "null needle"
    # }
    return $haystack.ToLower().Contains($needle.ToLower())
}

function WalkEntries() {
    param(
        [Microsoft.Win32.RegistryKey]$RegKey
    )

    :loop foreach ($entryName in $RegKey.GetValueNames()) {
        $item = "$($RegKey.Name) :: $entryName"
        # Write-Host $item

        if ($script:MatchEntryName) {
            if (IsMatch $entryName $script:Find) {
                $script:foundEntryNames.Add($item) | Out-Null
            }
        }

        if ($script:MatchEntryValue) {
            # https://docs.microsoft.com/en-us/dotnet/api/microsoft.win32.registryvaluekind?view=net-6.0
            $valueType = $RegKey.GetValueKind($entryName)
            switch -Exact ($valueType) {
                ([Microsoft.Win32.RegistryValueKind]::String) { break }
                ([Microsoft.Win32.RegistryValueKind]::ExpandString) { break }
                default { continue loop }
            }

            $value = $RegKey.GetValue($entryName)
            # Write-Host $value
            if (IsMatch $value $script:Find) {
                $script:foundEntryValues.Add($item) | Out-Null
            }
        }
    }
}

function WalkRegKey() {
    param(
        [Microsoft.Win32.RegistryKey]$RegKey
    )

    if ($script:MatchKeyPath) {
        if (IsMatch $RegKey.Name $script:Find) {
            $script:foundKeys.Add($RegKey.Name) | Out-Null
        }
    }

    # Write-Host $RegKey.Name
    WalkEntries -RegKey $RegKey

    foreach ($subkeyName in $RegKey.GetSubKeyNames()) {
        try {
            $subkey = $RegKey.OpenSubKey($subkeyName)
        }
        catch {
            Write-Output "Failed to open $($RegKey.Name)\ $subkeyName"
            continue
        }

        if ($subkey -eq $null) {
            Write-Output "Failed to open $($RegKey.Name)\ $subkeyName"
            continue
        }

        if ($script:MatchKeyName) {
            if (IsMatch $subkeyName $script:Find) {
                $script:foundKeys.Add($subkey.Name) | Out-Null
            }
        }

        WalkRegKey -RegKey $subkey
    }
}

$rootKey = Get-Item -LiteralPath Registry::$script:Root
if ($rootKey -eq $null) {
    Write-Error "Failed to open $script:Root"
    exit(1)
}

WalkRegKey -RegKey $rootKey

Write-Host "Found keys=$($script:foundKeys.Count) entryNames=$($script:foundEntryNames.Count) entryValues=$($script:foundEntryValues.Count)"

foreach ($key in $script:foundKeys) {
    Add-Content -LiteralPath $script:OutFile -Value "key $key" -Encoding utf8
}

foreach ($key in $script:foundEntryNames) {
    Add-Content -LiteralPath $script:OutFile -Value "entry $key" -Encoding utf8
}

foreach ($key in $script:foundEntryValues) {
    Add-Content -LiteralPath $script:OutFile -Value "value $key" -Encoding utf8
}

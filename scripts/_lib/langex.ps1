
# 将多级数组展平
filter Flatten-Array {
    if ($_ -is [array]) { $_ | Flatten-Array }
    else { $_ }
}

# 如果字符串中包含空格，且不是双引号开头，则加上双引号
filter Quote-Arg {
    $s = $_.ToString()
    if ($s.Contains(' ')) {
        if ($s -match '^"') {
            return $s
        }
        return "`"$s`""
    }
    return $s
}

function Get-ItemProperty-OrNull {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [Parameter(Mandatory)]
        [string]$Name
    )

    try {
        return Get-ItemProperty -LiteralPath $LiteralPath -Name $Name
    }
    catch [System.Management.Automation.ItemNotFoundException] {
        return $null
    }
}

function Test-CommandExists($command) {
    try {
        if (Get-Command -ErrorAction SilentlyContinue $command) {
            return $true
        }
    }
    catch {
        return $false
    }
}

function Test-RegistryItem {
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$ItemName,

        [switch]$PathMustExist,

        [switch]$ItemDeprecated,

        [object]$ItemPreferredValue,

        [string]$Message
    )

    try {
        [Microsoft.Win32.RegistryKey]$regKey = Get-Item -LiteralPath Registry::$Path
    }
    catch [System.Management.Automation.ItemNotFoundException] {
        # path not exsit
        if ($PathMustExist) {
            throw $_
        }
        return
    }

    try {
        $valueKind = $regKey.GetValueKind($entry)
        $value = $regKey.GetValue($entry)
    }
    catch [System.Management.Automation.ParentContainsErrorRecordException] {
        Write-Warning "KeyNotExist $regEntryName :: $regKeyName"
    }

    try {
        $prop = Get-ItemProperty -LiteralPath Registry::$Path -Name $ItemName
        if ($ItemDeprecated) {
            Write-Warning "Deprecated $Path ${ItemName}: $Message"
        }
        if (($ItemPreferredValue -ne $null) -and ($prop.Value -ne $ItemPreferredValue)) {
            Write-Warning "NotPreferred $Path ${ItemName}: $Message (current=$($prop.Value) preferred=$ItemPreferredValue)"
        }
        return $prop
    }
    catch [System.Management.Automation.PSArgumentException] {
        # property not exist
        # weird it's not [System.Management.Automation.PropertyNotFoundException]
        if ($ItemDeprecated) {
            return
        }
        if ($ItemPreferredValue -ne $null) {
            Write-Warning "NotPreferred $Path ${ItemName}: $Message"
            return
        }

    }
    catch {
        # unexpected
        Write-Host "UncaughtException: $($_.Exception.GetType()) $_"
        return
    }
}

param()

$matchedEntries = [System.Collections.Generic.LinkedList[object]]::new()
$matchedKeys = [System.Collections.Generic.LinkedList[object]]::new()
$matchedValues = [System.Collections.Generic.LinkedList[object]]::new()

function Walk-Items {
    param(
        [Microsoft.Win32.RegistryKey]$Entry,
        [string]$Find,
        [switch]$dummy
    )
    $keys = $Entry.GetValueNames()
    foreach ($key in $keys) {
        if ($key -match $Find) {
            Write-Host "$Path $key"
            $matchedKeys.Add(@{
                Path = $Path;
                Key = $key;
            }) | Out-Null
            continue
        }

        $value = $Entry.GetValue($key)
        if ($value -match $Find) {
            Write-Host "$Path $key $value"
            $matchedValues.Add(@{
                Path = $Path;
                Key = $key;
                Value = $value;
            }) | Out-Null
            continue
        }
    }
}

function Walk-Entries {
    param(
        [string]$Path,
        [string]$Find,
        [switch]$dummy
    )
    try {
        $entry = Get-Item -Path $Path
        if ($entry -eq $null) {
            Write-Host "Unknown $Path null"
            return
        }
        if ($entry.GetType().FullName -ne 'Microsoft.Win32.RegistryKey') {
            Write-Host "Unknown $Path $($entry.GetType().FullName)"
            return
        }
    }
    catch {
        Write-Host "Unknown $Path $($_.ToString())"
        return
    }

    $subkeys = $entry.GetSubKeyNames()
    foreach ($subkey in $subkeys) {
        if ($subkey -match $Find) {
            Write-Host "$Path $subkey"
            $matchedEntries.Add(@{
                Path = $Path;
                Key = $subkey;
            }) | Out-Null
        }

        Walk-Entries -Path "$Path\$subkey" -Find $Find
    }

    Walk-Items -Entry $entry -Find $Find
}

Walk-Entries -Path "Registry::HKEY_LOCAL_MACHINE" -Find ".*C:\\my\\installed\\.+"
Walk-Entries -Path "Registry::HKEY_CURRENT_USER" -Find ".*C:\\my\\installed\\.+"

$matchedEntries | ConvertTo-Json | Out-File "entries.json"
$matchedKeys | ConvertTo-Json | Out-File "keys.json"
$matchedValues | ConvertTo-Json | Out-File "values.json"

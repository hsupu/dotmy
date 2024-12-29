<#
.SYNOPSIS
实际执行重命名

.DESCRIPTION

.PARAMETER Path
list-regs.ps1 生成的记录文件

.PARAMETER From
匹配

.PARAMETER To
替换

.EXAMPLE

#>
param(
    [Parameter(Mandatory)]
    [string]$Path,

    [Parameter(Mandatory)]
    [string]$From,

    [Parameter(Mandatory)]
    [string]$To,

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$lines = Get-Content $script:Path
foreach ($line in $lines) {
    # skip empty lines
    if (-not ($line -match '^(\S+) (.+)$')) {
        continue
    }
    # Write-Host $line

    $type = $Matches[1]
    switch -Exact ($type) {
        "value" {
            if (-not ($Matches[2] -match '^(.+) :: (.*)$')) {
                Write-Warning "invalid $line"
                break
            }

            $regKeyName = $Matches[1]
            $regEntryName = $Matches[2]
            # Write-Host "$regKeyName :: $regEntryName"

            try {
                [Microsoft.Win32.RegistryKey]$regKey = Get-Item -LiteralPath Registry::$regKeyName
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning "KeyNotExist $regKeyName"
            }

            try {
                # it throws ParentContainsErrorRecordException if KeyNotExist
                $valueKind = $regKey.GetValueKind($regEntryName)

                # it just returns $null if KeyNotExist
                $value = $regKey.GetValue($regEntryName)
            }
            catch [System.Management.Automation.ParentContainsErrorRecordException] {
                Write-Warning "EntryNotExist $regKeyName :: $regEntryName"
            }

            # Write-Host $value

            if (-not $value.ToLower().Contains($script:From.ToLower())) {
                Write-Host "stale $line"
                continue
            }

            # Write-Host "update $line"

            $replaced = $value -ireplace [Regex]::Escape($script:From), $script:To
            # Write-Host $replaced

            # Exception calling "SetValue" with "3" argument(s): "Cannot write to the registry key."
            # $regKey.SetValue($regEntryName, $replaced, [Microsoft.Win32.RegistryValueKind]$valueKind) | Out-Null

            if ($DryRun) {
                Write-Output "$($valueKind) $($regKeyName).$($regEntryName): $($value) => $($replaced)"
            }
            else {
                if ([string]::IsNullOrEmpty($regEntryName)) {
                    # or Set-ItemProperty -Name "(default)"
                    Set-Item -LiteralPath Registry::$regKeyName -Value $replaced -Type $valueKind
                }
                else {
                    Set-ItemProperty -LiteralPath Registry::$regKeyName -Name $regEntryName -Value $replaced -Type $valueKind
                }
            }
        }

        default {
            Write-Warning "notimpl $line"
        }
    }
}

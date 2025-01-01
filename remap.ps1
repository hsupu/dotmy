<#
.PARAMETER MapPath
格式为 "path/to/mapping.ps1[:group]"，默认为 "$env:DOTMY/profiles/$(hostname)/mapping.ps1"
group 留空表示使用变量 mapping，否则使用 ${group}_mapping

.PARAMETER FixBroken
尝试修复已经存在、指向目标与预期不同、且不存在的链接

.PARAMETER FixOther
尝试修复已经存在、指向目标与预期不同、但目标存在的链接

.NOTES
无论如何，不会自动覆盖已存在的非链接文件
#>
param(
    [string]$MapPath,

    [switch]$FixBroken,
    [switch]$FixOther,

    [switch]$DryRun
)

# $DebugPreference = 'Continue'
$InformationPreference = 'Continue'
$WarningPreference = 'Continue'
$ErrorActionPreference = 'Stop'
trap { throw $_ }

# 不常变之参数
#
$UseJunction = $false

if ('' -eq $env:DOTMY) {
    $env:DOTMY = $PSScriptRoot
    [Environment]::SetEnvironmentVariable('DOTMY', $env:DOTMY, 'User')
}
. (Join-Path $env:DOTMY "scripts/_lib/os.ps1")

$isPwsh = ([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("6.0")) -ge 0
if (-not $isPwsh) {
    throw "PowerShell ≥ 7 is required"
}

$IncludedProfiles = [System.Collections.Generic.HashSet[string]]::new()
$MergedMappings = [System.Collections.Generic.Dictionary[string, object]]::new()
$MergedUserEnv = [System.Collections.Generic.Dictionary[string, object]]::new()

function abspath([string]$Path) {
    return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
}

function normslash([string]$Path, [string]$c = [IO.Path]::DirectorySeparatorChar) {
    # 假设平台是 Windows-style
    return $Path.Replace('/', $c)
}

function normpath {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$FullName,
        [switch]$TrailingSlash
    )

    $c = [IO.Path]::DirectorySeparatorChar
    $FullName = normslash $FullName $c

    $hasTrailingSlash = $FullName.EndsWith($c)
    if ($hasTrailingSlash) {
        $FullName = $FullName.Substring(0, $FullName.Length - 1)
    }

    if ($TrailingSlash) {
        return "$FullName$c"
    }
    else {
        return $FullName
    }
}

function HandleMapping([object[]]$parts) {
    if (2 -gt $parts.Count) {
        Write-Error -ErrorAction Continue "InvalidMapping: $parts"
        return
    }
    $dstText0 = $parts[0]
    $srcText0 = $parts[1]

    if (2 -eq $parts.Count) {
        $attrs = @{}
    }
    else {
        $attrs = $parts[2]
    }
    $needCopy = $attrs.ContainsKey('copy') -and $attrs['copy']
    $needSudo = $attrs.ContainsKey('sudo') -and $attrs['sudo']
    $needRelativeToDst = $attrs.ContainsKey('relative') -and $attrs['relative']
    $needExist = (-not $attrs.ContainsKey('exist')) -or $attrs['exist']

    if ($parts.Count -gt 3) {
        Write-Warning -WarningAction Continue "ExtraParts: $($parts[3..($parts.Count - 1)])"
    }

    $c = [IO.Path]::DirectorySeparatorChar
    $dstText = normslash $ExecutionContext.InvokeCommand.ExpandString($dstText0) $c
    $srcText = normslash $ExecutionContext.InvokeCommand.ExpandString($srcText0) $c
    $dstIsDir = $dstText.EndsWith($c)
    $srcIsDir = $srcText.EndsWith($c)

    # src 显式写为目录，一是为了决定 mklink 参数，二是可以检查 src 如果存在、是否为目录
    if ($srcIsDir) {
        $srcText = $srcText.Substring(0, $srcText.Length - 1)
    }
    $srcLastName = [IO.Path]::GetFileName($srcText)

    if (-not $needRelativeToDst) {
        $srcText = abspath $srcText
    }

    # dst 保证是绝对路径
    $dstText = abspath $dstText

    # dst 如果是目录，则实际是该目录下的与 src 同名的文件/子目录
    if ($dstIsDir) {
        $dstDir = $dstText
        $dstText = Join-Path $dstDir $srcLastName
    }
    else {
        $dstDir = Split-Path -Parent $dstText
    }

    $dst = Get-Item -ErrorAction SilentlyContinue -LiteralPath $dstText
    if ($null -ne $dst) {
        if ('' -eq [string]($dst.LinkType)) {
            if ($needCopy) {
                Write-Warning -WarningAction Continue "DstFileExist (skip): `"$dstText0`" => `"$srcText`" (copy)"
            }
            else {
                Write-Warning -WarningAction Continue "DstNotALink (skip): `"$dstText0`" => `"$srcText`""
            }
            return
        }

        # Write-Host "LinkExist: $($dst.LinkType) `"$dstText0`" => `"$($dst.LinkTarget)`""
        $tgtText = normpath $dst.LinkTarget
        $tgt = $dst.ResolveLinkTarget($false) # just direct target

        $target_is_expected = $tgtText -eq $srcText
        $target_is_existed = $null -ne $tgt

        if ($target_is_expected) {
            if ($target_is_existed) {
                Write-Information -InformationAction Continue "LinkExist: $($dst.LinkType) `"$dstText0`" => `"$srcText`""
            }
            else {
                Write-Warning -WarningAction Continue "LinkExist.Broken: $($dst.LinkType) `"$dstText0`" => `"$srcText`""
            }
            return
        }

        if ($target_is_existed) {
            Write-Warning -WarningAction Continue "LinkOther: $($dst.LinkType) `"$dstText0`" => `"$tgtText`" (expect `"$srcText`")"
            if (-not $FixOther) {
                return
            }
        }
        else {
            Write-Warning -WarningAction Continue "LinkOther.Broken: $($dst.LinkType) `"$dstText0`" => `"$tgtText`" (expect `"$srcText`")"
            if (-not $FixBroken) {
                return
            }
        }
    }

    if ($needExist) {
        if ($needRelativeToDst) {
            $src = Get-Item -ErrorAction SilentlyContinue -LiteralPath (Join-Path $dstDir $srcText)
        }
        else {
            $src = Get-Item -ErrorAction SilentlyContinue -LiteralPath $srcText
        }

        if ($null -eq $src) {
            Write-Warning -ErrorAction Continue "SrcNotExist (skip): `"$dstText0`" => `"$srcText0`" (as `"$srcText`")"
            return
        }

        # 检查 src 目录的声明和实际情况是否相符，注意：Windows 关心链接源是文件还是目录
        if ($srcIsDir -ne $src.Attributes.HasFlag([IO.FileAttributes]::Directory)) {
            Write-Warning -ErrorAction Continue "SrcTypeAmbiguity (skip): `"$dstText0`" => `"$srcText`""
            return
        }
    }

    if ($needSudo -xor $global:isAdmin) {
        Write-Warning -ErrorAction Continue "SudoMismatch (skip): isAdmin=$global:isAdmin `"$dstText0`" => `"$srcText`""
        return
    }

    if ($script:MergedMappings.ContainsKey($dstText)) {
        Write-Information -InformationAction Continue "DstDup (skip): `"$dstText0`""
        continue
    }

    $script:MergedMappings.Add($dstText, @{
        'SrcRaw' = $srcText0;
        'DstRaw' = $dstText0;
        'SrcText' = $srcText;
        'DstText' = $dstText;
        'SrcPath' = $src.FullName;
        'SrcIsDir' = $srcIsDir;
        'Copy' = $needCopy;
        'Sudo' = $needSudo;
    }) | Out-Null
}

function IncludeMapping([string]$Path) {
    if ($Path.Contains(':')) {
        $Path, $Group = $Path -split ':', 2
        $Group = $ExecutionContext.InvokeCommand.ExpandString($Group)
    }
    else {
        $Group = ''
    }

    $ProfileName = "${Path}:${Group}".ToLower()
    if ($script:IncludedProfiles.Contains($ProfileName)) {
        return
    }
    $script:IncludedProfiles.Add($ProfileName) | Out-Null

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        # nop
    }
    elseif (Test-Path -LiteralPath $Path -PathType Container) {
        $Path = Resolve-Path -ErrorAction Stop "$Path\mapping.ps1"
    }
    else {
        # treat as a profile name
        $Path = Resolve-Path -ErrorAction Stop "$PSScriptRoot\profiles\$Path\mapping.ps1"
    }

    $DirPath = Split-Path -Parent $Path
    Push-Location $DirPath
    try {
        $ret = New-Module -ScriptBlock {
            param([string]$Path, [string]$Group)
            . $Path
            if ('' -eq $Group) {
                $MappingVarName = 'mapping'
                $UserEnvVarName = 'userenv'
                $IncludesVarName = 'includes'
            }
            else {
                $MappingVarName = "${Group}_mapping"
                $UserEnvVarName = "${Group}_userenv"
                $IncludesVarName = "${Group}_includes"
            }
            $mapping = (Get-Variable -ErrorAction SilentlyContinue -Name $MappingVarName -Scope Private).Value
            $userenv = (Get-Variable -ErrorAction SilentlyContinue -Name $UserEnvVarName -Scope Private).Value
            $includes = (Get-Variable -ErrorAction SilentlyContinue -Name $IncludesVarName -Scope Private).Value
            return @($mapping, $userenv, $includes)
        } -ArgumentList @($Path, $Group) -ReturnResult

        if ($null -ne $ret[0]) {
            foreach ($e in $ret[0]) {
                if (($null -eq $e) -or (0 -eq $e.Count)) {
                    continue
                }
                HandleMapping $e
            }
        }

        if ($null -ne $ret[1]) {
            # Write-Host "userenv = $($ret[1] | Format-Table | Out-String)"
            foreach ($kvp in $ret[1].GetEnumerator()) {
                # TODO expandable?
                $k = $kvp.Key
                $v = $kvp.Value
                if ($script:MergedUserEnv.ContainsKey($k)) {
                    Write-Warning -ErrorAction Continue "UserEnvDuplicated (skip): $k = $v"
                    continue
                }
                $script:MergedUserEnv.Add($k, $v) | Out-Null
            }
        }

        if ($null -ne $ret[2]) {
            foreach ($e in $ret[2]) {
                if ('' -eq [string]$e) {
                    continue
                }
                IncludeMapping -Path $e
            }
        }
    }
    finally {
        Pop-Location
    }
}

function PerformMappings {
    param(
        [switch]$DryRun
    )

    foreach ($kvp in $script:MergedMappings.GetEnumerator())
    {
        $needCopy = $kvp.Value['Copy']
        $srcText = $kvp.Value['SrcText']
        $dstText = $kvp.Value['DstText']
        $srcIsDir = $kvp.Value['SrcIsDir']

        $dstParent = abspath (Join-Path $dstText "..")
        if (-not (Test-Path -LiteralPath $dstParent)) {
            if ($DryRun) {
                Write-Host "mkdir $dstParent"
            }
            else {
                mkdir -p $dstParent -ErrorAction Stop | Out-Null
            }
        }
        if (-not $DryRun -and -not (Test-Path -LiteralPath $dstParent -PathType Container)) {
            throw "DstParentNotADir: $dstParent"
        }

        $dst = Get-Item -ErrorAction SilentlyContinue -LiteralPath $dstText
        if ($null -ne $dst) {
            if ($DryRun) {
                Write-Host "rm $dstText"
            }
            else {
                $dst.Delete()
            }
        }

        if ($srcIsDir) {
            if ($needCopy) {
                Write-Warning -ErrorAction Continue "CopyDirNotSupported: $srcText => $dstText (copy)"
                continue
            }

            # Write-Debug "DirLink: $srcText => `"$dstText`""
            if ($UseJunction) {
                if ($DryRun) {
                    Write-Host "cmd /c mklink /j `"$dstText`" `"$srcText`""
                }
                else {
                    & cmd /c mklink /j "`"$dstText`"" "`"$srcText`""
                    if (0 -ne $LASTEXITCODE) {
                        throw "cmd returned exitcode $LASTEXITCODE : `"$dstText`""
                    }
                }
            }
            else {
                if ($DryRun) {
                    Write-Host "cmd /c mklink /d `"$dstText`" `"$srcText`""
                }
                else {
                    & cmd /c mklink /d "`"$dstText`"" "`"$srcText`""
                    if (0 -ne $LASTEXITCODE) {
                        throw "cmd returned exitcode $LASTEXITCODE : `"$dstText`""
                    }
                }
            }
        }
        else {
            if ($needCopy) {
                # Write-Warning -ErrorAction Continue "CopyFileNotSupported: $srcText => $dstText (copy)"
                if ($DryRun) {
                    Write-Host "Copy-Item $srcText $dstText"
                }
                else {
                    Copy-Item -ErrorAction Stop -LiteralPath $srcText -Destination $dstText
                }
                continue
            }
            else {
                # Write-Debug "FileLink: $srcText => `"$dstText`""
                if ($DryRun) {
                    Write-Host "cmd /c mklink `"$dstText`" `"$srcText`""
                }
                else {
                    & cmd /c mklink "`"$dstText`"" "`"$srcText`""
                    if (0 -ne $LASTEXITCODE) {
                        throw "cmd returned exitcode $LASTEXITCODE : `"$dstText`""
                    }
                }
            }
        }
    }
}

function main {
    $hostname = (& hostname).ToLower()
    if ('' -eq $hostname) {
        throw "Unexpected. hostname is empty"
    }

    if ('' -eq $MapPath) {
        $MapPath = $hostname # will be expanded later
    }

    IncludeMapping -Path $MapPath
    PerformMappings -DryRun:$DryRun
}

main

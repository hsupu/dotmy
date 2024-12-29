<#

.DESCRIPTION
要求记录文件以以下形式列出，每行一组
hash path

如
0CC6CE201A507033DAA103B0155C72C3F471299FCC5030E3AE76F2D836830F32 path to file

#>
param(
    [string]$RefPath,
    [string]$SrcPath,

    [switch]$PrintMissingRef,
    [switch]$PrintMissingSrc,

    [switch]$PrintDiffHashSamePath,
    [switch]$PrintSameHashSamePath,
    [switch]$PrintSameHashDiffPath,
    [switch]$PrintSameHashInRef,
    [switch]$PrintSameHashInSrc,

    [switch]$dummy
)

$RawRefs = Get-Content -LiteralPath $RefPath
$RawSrcs = Get-Content -LiteralPath $SrcPath

$refHashToPath = [System.Collections.Generic.Dictionary[string, string]]::new($RawRefs.Length)
$refPathToHash = [System.Collections.Generic.Dictionary[string, string]]::new($RawRefs.Length)
$srcHashToPath = [System.Collections.Generic.Dictionary[string, string]]::new($RawSrcs.Length)
$srcPathToHash = [System.Collections.Generic.Dictionary[string, string]]::new($RawSrcs.Length)

foreach ($raw in $RawRefs) {
    $parts = $raw -split ' ', 2
    $hash = $parts[0]
    $path = $parts[1]

    if ($refHashToPath.ContainsKey($hash)) {
        if ($PrintSameHashInRef) {
            $existed = $refHashToPath[$hash]
            Write-Output "same-ref $path <=> $existed"
        }
    }
    else {
        $refHashToPath.Add($hash, $path) | Out-Null
    }

    $refPathToHash.Add($path, $hash) | Out-Null
}

foreach ($raw in $RawSrcs) {
    $parts = $raw -split ' ', 2
    $hash = $parts[0]
    $path = $parts[1]

    if ($srcHashToPath.ContainsKey($hash)) {
        if ($PrintSameHashInSrc) {
            $existed = $srcHashToPath[$hash]
            Write-Output "same-src $path <=> $existed"
        }
    }
    else {
        $srcHashToPath.Add($hash, $path) | Out-Null
    }

    $srcPathToHash.Add($path, $hash) | Out-Null
}

if ($PrintSame) {
    $refKeys = $refHashToPath.Keys
    $srcKeys = $srcHashToPath.Keys

    $items = [System.Linq.Enumerable]::Intersect($srcKeys, $refKeys) | Write-Output -NoEnumerate
    Write-Host "intersect hash $($items.Count) from src $($srcKeys.Count) and ref $($refKeys.Count)"

    foreach ($hash in $items) {
        $ref = $refHashToPath[$hash]
        $src = $srcHashToPath[$hash]
        if ($ref -eq $src) {
            if ($PrintSameHashSamePath) {
                Write-Output "same $ref"
            }
        }
        else {
            if ($PrintSameHashDiffPath) {
                Write-Output "diff-path : src $src <=> ref $ref"
            }
        }
    }
}

if ($PrintDiffHashSamePath -or $PrintMissingSrc -or $PrintMissingRef) {
    $refKeys = $refPathToHash.Keys
    $srcKeys = $srcPathToHash.Keys

    if ($PrintDiffHashSamePath) {
        $items = [System.Linq.Enumerable]::Intersect($srcKeys, $refKeys) | Write-Output -NoEnumerate
        Write-Host "intersect path $($items.Count) from src $($srcKeys.Count) and ref $($refKeys.Count)"

        foreach ($path in $items) {
            $ref = $refPathToHash[$path]
            $src = $srcPathToHash[$path]
            if ($ref -ne $src) {
                Write-Output "diff-hash $path : src $src <=> ref $ref"
            }
        }
    }

    if ($PrintMissingSrc) {
        $items = [System.Linq.Enumerable]::Except($refKeys, $srcKeys) | Write-Output -NoEnumerate
        Write-Host "diff path $($items.Count) from ref $($refKeys.Count) to src $($srcKeys.Count)"

        foreach ($path in $items) {
            Write-Output "missing-src : ref $path"
        }
    }

    if ($PrintMissingRef) {
        $items = [System.Linq.Enumerable]::Except($srcKeys, $refKeys) | Write-Output -NoEnumerate
        Write-Host "diff path $($items.Count) from src $($srcKeys.Count) to ref $($refKeys.Count)"

        foreach ($path in $items) {
            Write-Output "missing-ref : src $path"
        }
    }
}

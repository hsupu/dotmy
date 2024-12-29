param(
    [Parameter(Mandatory)]
    [string]$Path
)

$ignores = @(
    '\.git\'
)

if ([string]::IsNullOrEmpty($Path)) {
    $Path = $PWD
}

$BaseDir = Get-Item $Path

function Get-RelativeName() {
    param(
        [string]$Name,
        [switch]$IsDirectory
    )

    if ($Name.StartsWith($script:BaseDir.FullName)) {
        $relname = $Name.Substring($script:BaseDir.FullName.Length)
    }
    else {
        $relname = $Name
    }
    if ($IsDirectory) {
        $relname = "$relname\"
    }
    return $relname
}

function Look-Dir() {
    param(
        [System.IO.DirectoryInfo]$Dir,

        [ref]$Sum,

        [switch]$dummy
    )
    $dirSum = 0

    $entries = Get-ChildItem $Dir
    foreach ($entry in $entries) {
        $relname = Get-RelativeName -Name $entry.FullName -IsDirectory:($entry.Attributes.HasFlag([System.IO.FileAttributes]::Directory))

        if ($relname -in $ignores) {
            Write-Host "skip $relname"
            continue
        }

        if ($null -ne $entry.LinkTarget) {
            Write-Output ([string]::Format("{0,-10} {1} => {2}", -1, $relname, $entry.LinkTarget));
            continue
        }

        if ($entry.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
            $entrySum = 0
            Look-Dir -Dir $entry -Sum ([ref]$entrySum)
            $dirSum += $entrySum
            continue
        }

        $dirSum += $entry.Length

        Write-Output ([string]::Format("{0,-10} {1}", $entry.Length, $relname))
    }

    $relname = Get-RelativeName -Name $Dir.FullName -IsDirectory
    Write-Output ([string]::Format("{0,-10} {1}", $dirSum, $relname))

    if ($null -ne $Sum.Value) {
        $Sum.Value += $dirSum
    }
}

Look-Dir -Dir $BaseDir

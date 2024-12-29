param (
    [Parameter(Position=0)]
    [string]$Url,

    [Parameter(Position=1)]
    [string]$DstRoot,

    [switch]$NoLink,
    [switch]$NoOpen,

    [Parameter(ValueFromPipeline)]
    [string]$Raw
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

if ([string]::IsNullOrEmpty($Url)) {
    # try $Raw
    $Raw = $Raw.Trim();
    if ($Raw.StartsWith("AzCopy copy")) {
        if ($Raw -match "`"([^`"]+)`"") {
            $Url = $Matches[0]
            Write-Host "Matched $Url"
        }
    }
    else {
        Write-Error "Failed to parse raw=`"$Raw`"."
        exit 1
    }
}
else {
    # use $Url directly
    $Url = $Url.Trim();
}

if ([string]::IsNullOrEmpty($Url)) {
    Write-Error "-Url not specified."
    exit 1
}

if ([string]::IsNullOrEmpty($DstRoot)) {

    function StringOrDefault([string]$value, [string]$default)
    {
        if ([string]::IsNullOrEmpty($value)) {
            return $default
        }
        return $value
    }

    $DstRoot = StringOrDefault -value $env:MY_ADO_CLOUDTEST_ROOT -default "C:\ct"
}
else {
    $DstRoot = $DstRoot.Trim();
}

if (!(Test-Path $DstRoot)) {
    New-Item -ItemType Directory -Path $DstRoot -ErrorAction Stop
}

function Run-Azcopy {
    param(
        [string]$Url,
        [string]$DstDir
    )
    $proc = Start-Process `
        -FilePath "azcopy.exe" `
        -ArgumentList @( `
            "copy", $Url, `
            "--decompress", `
            "--recursive=true", `
            "--from-to", "BlobLocal", $DstDir `
        ) `
        -NoNewWindow -Wait -PassThru
    if ($proc.ExitCode -ne 0) {
        Write-Host "azcopy.exe exited with code $($proc.ExitCode)"
    }
}

$dirname = Get-Date -Format "yyMMdd-HHmmss"
$dirpath = Join-Path $DstRoot $dirname

Write-Host "azcc: dst $dirpath"
Run-Azcopy -Url $Url -DstDir $dirpath

if (-not (Test-Path -PathType Container -Path $dirpath)) {
    # Write-Error "Failed to azcopy, exitcode=$LASTEXITCODE"
    exit 1
}

if (-not $NoLink) {
    # Write-Host "link $dirpath"
    $linkname = "link"
    Push-Location $DstRoot
    try {
        if (Test-Path $linkname) {
            Remove-Item $linkname -ErrorAction Stop
        }
        & cmd /c mklink /d $linkname "$dirname\GeneralAttachment\TestResults\saved"
    }
    finally {
        Pop-Location
    }
}

if (-not $NoOpen) {
    Write-Host "open $dirpath"
    & "explorer.exe" @($dirpath)
}

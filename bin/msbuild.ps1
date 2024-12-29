<#
.SYNOPSIS
Run MSBuild out of a Developer PowerShell

.NOTES
241209

.NOTES
Install-Module -Scope CurrentUser VSSetup

.NOTES
For .NET projects, see a modern way (but there're some different) from https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-msbuild

#>
[CmdletBinding()]
param (
    [Parameter(Mandatory, Position=0)]
    [string]$Project,

    [AllowEmptyString()]
    [string]$Target,

    [switch]$Rebuild,
    [switch]$Clean,

    [switch]$ReleaseBuild,
    [switch]$Retail,

    [switch]$AnyCPU,

    [switch]$V,
    [switch]$VV,

    [Parameter(ValueFromRemainingArguments)]
    [AllowEmptyCollection()]
    $Remaining
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$Project = Resolve-Path -LiteralPath $Project
if (Test-Path -PathType Container $Project) {
    $ProjectDir = $Project
    $ProjectName = "."
}
else {
    $ProjectDir = [IO.Path]::GetDirectoryName($Project)
    $ProjectName = [IO.Path]::GetFileName($Project)
}

function main {
    # not work by now
    # see https://github.com/dotnet/msbuild/issues/1596
    $env:DOTNET_CLI_UI_LANGUAGE = "en-US"
    $env:PreferredUILang = "en-US"
    $env:VSLANG = "1033"
    # chcp 65001

    $vsInstance = Get-VSSetupInstance -All | ? { $_.State -eq [Microsoft.VisualStudio.Setup.Configuration.InstanceState]::Complete } | Select-Object -First 1
    if ($null -eq $vsInstance) {
        throw "Failed to Get-VSSetupInstance"
    }

    if ('' -eq [string]$Target) {
        $Target = "Build"
    }
    $Targets = $Target.Split(',')
    if ($Rebuild) {
        $Targets = @("Rebuild") + $Targets
    }
    elseif ($Clean) {
        $Targets = @("Clean")
    }

    if ($Retail) {
        $ReleaseBuild = $true
    }

    $Targets = [string]::Join(',', $Targets)
    $Configuration = if ($ReleaseBuild) {"Release"} else {"Debug"}
    $Platform = if ($AnyCPU) {"Any CPU"} else {"x64"}

    $exeArgs = @(
        $ProjectName,
        "-t:$Targets",
        "-p:Configuration=$Configuration",
        "-p:Platform=$Platform",
        "-NoLogo"
    )

    if ($VV) {
        $exeArgs += @("-verbosity:diag")
    }
    elseif ($V) {
        $exeArgs += @("-verbosity:detailed")
    }
    else {
        $exeArgs += @("-MaxCpuCount:4")
    }

    if ($env:PROCESSOR_ARCHITECTURE -ieq 'AMD64') {
        # Hostx64
        & "$($vsInstance.InstallationPath)\MSBuild\Current\Bin\amd64\MSBuild.exe" @exeArgs
    }
    elseif ($env:PROCESSOR_ARCHITECTURE -ieq 'x86') {
        # Hostx86
        & "$($vsInstance.InstallationPath)\MSBuild\Current\Bin\MSBuild.exe" @exeArgs
    }
    else {
        throw "Unsupported CPU arch: $($env:PROCESSOR_ARCHITECTURE)"
    }
    if (0 -ne $LASTEXITCODE) {
        throw "msbuild exited with code $LASTEXITCODE"
    }
}

Push-Location $ProjectDir
try {
    main
}
finally {
    Pop-Location
}


# OS

function Test-Windows {
    param(
        [switch]$NoThrow
    )
    # Starting from PowerShell 6.0, the Variable 'IsWindows' is a readonly automatic variable
    # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.3
    if ($PSVersionTable.PSVersion.Major -lt 6) {
        # $IsWindows = $env:OS -ne 'Windows_NT'
        $IsWindows = [System.Environment]::OSVersion.Platform -eq "Win32NT"
    }
    if ($IsWindows) {
        if (-not $NoThrow) {
            throw "Not run on Windows"
        }
    }
    return $IsWindows
}

function PrintWindowsProductInfo {
    $value = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName | Select-Object -ExpandProperty ProductName
    Write-Host $value

    # https://learn.microsoft.com/en-us/dotnet/api/microsoft.powershell.commands.producttype?view=powershellsdk-7.4.0
    $osinfo = Get-CimInstance -ClassName Win32_OperatingSystem
    Write-Host "ProductType=$([Microsoft.PowerShell.Commands.ProductType]$info.ProductType)"

    # 用词不同，如 1 - WinNT
    $value = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\ProductOptions" -Name ProductType | Select-Object -ExpandProperty ProductType
    Write-Host $value
}

# Privilege
#

function Test-Admin {
    param(
        [switch]$NoThrow
    )
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    # $isAdmin = $currentUser.Groups -contains 'S-1-5-32-544')
    $principal = [Security.Principal.WindowsPrincipal]::new($currentUser)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin -and -not $NoThrow) {
        throw "Required to be run as Administrator"
    }
    return $isAdmin
}

$global:isAdmin = Test-Admin -NoThrow

function FindExecutable {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [string[]]$Hints = @()
    )

    $pathes = @()
    if (0 -lt $Hints.Length) {
        $pathes += $Hints

    }
    $pathes += $env:PATH -split ';'
    # $pathes += $PSScriptRoot

    $split = $Name.LastIndexOf('.')
    if (0 -lt $split) {
        $exe = $Name.Substring(0, $split)
        $exts = @($Name.Substring($split))
    }
    else {
        $exe = $Name
        $exts = @('.exe', '.bat', '.cmd', '.ps1')
    }
    foreach ($path in $pathes) {
        foreach ($ext in $exts) {
            $fullpath = Join-Path $path "$exe$ext"
            if (Test-Path -LiteralPath $fullpath -PathType Leaf) {
                return $fullpath
            }
        }
    }
    throw "Executable not found: $exe`n$pathes"
}

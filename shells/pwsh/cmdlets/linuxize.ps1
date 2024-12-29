
$ErrorActionPreferenceOld = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
    If (-Not (Test-Path Variable:PSise)) { # not work in ISE
        # Install-Module -Scope CurrentUser Get-ChildItemColor
        Import-Module -ErrorAction Continue Get-ChildItemColor
    }

    # Remove-Alias -ErrorAction SilentlyContinue -Scope Global ls
    # Set-Alias -Scope Global ls Get-ChildItem # -Option AllScope
    # function global:ls {
    #     param(
    #         [Parameter(Position=0)]
    #         [string]$Path = ".",

    #         [switch]$Force,
    #         [switch]$Long,
    #         [switch]$NoColor
    #     )
    #     if (-not $NoColor -and (Test-CommandExists "Get-ChildItemColor")) {
    #         Get-ChildItemColor -Path $Path -Force:$Force
    #     }
    #     else {
    #         $items = Get-ChildItem -Path $Path -Force:$Force

    #         if ($Long) {
    #             $items | Format-Table -AutoSize -Property Mode, LastWriteTime, Length, Name
    #         }
    #         else {
    #             $items | Format-Wide
    #         }
    #     }
    # }
    New-Alias -Scope Global l ls # -Option AllScope
    function global:ll {
        ls -Force
    }

    # mac-style
    New-Alias -Scope Global open Invoke-Item

    New-Alias -Scope Global time Measure-Command

    New-Alias -Scope Global zip Compress-Archive
    New-Alias -Scope Global unzip Expand-Archive

    # function global:LinuxizePathSlash {
    #     param(
    #         [Parameter(Mandatory, Position=0, ValueFromPipeline)]
    #         [string]$Path
    #     )
    #     if (-not $Path.Contains('\')) {
    #         return $Path
    #     }
    #     return $Path.Replace('\', '/')
    # }

    filter global:LinuxizePathSlash {
        if (-not $_.Contains('\')) {
            return $_
        }
        return $_.Replace('\', '/')
    }

    function global:basename([string]$Path) {
        return [IO.Path]::GetFileName($Path)
    }

    function global:env {
        Get-ChildItem env:* | Sort-Object name
    }

    function global:touch([string]$file) { "" | Out-File $file -Encoding utf8 }

    function global:what($s) {
        if ($null -eq $s) {
            return "null"
        }
        if ($s -is [string]) {
            # $alias = Get-Alias -ErrorAction SilentlyContinue -Name $s

            $cmd = Get-Command -ErrorAction SilentlyContinue $s
            if ($cmd) {
                if ($cmd.CommandType -eq [System.Management.Automation.CommandTypes]::Alias) {
                    return "$($cmd.CommandType): $($cmd.DisplayName)"
                }

                return "$($cmd.CommandType): $($cmd.Definition)"
            }

            return "string"
        }

        $type = $s.GetType()
        return "$($type)"
    }
    Set-Alias -Scope Global type what

    function global:which($s) {
        try {
            $cmd = Get-Command $s -ErrorAction SilentlyContinue
            return $cmd.Definition
        }
        catch {
            # Write-Error $_
            return ""
        }
    }
}
finally {
    $ErrorActionPreference = $ErrorActionPreferenceOld
    # Remove-Variable ErrorActionPreferenceOld
}


$ErrorActionPreferenceOld = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
try {
    Set-Alias ls Get-ChildItem -Option AllScope
    New-Alias ll Get-ChildItemColorFormatWide -Option AllScope

    # mac-style
    New-Alias open Invoke-Item

    New-Alias time Measure-Command

    New-Alias zip Compress-Archive
    New-Alias unzip Expand-Archive

    function basename([string]$Path) {
        return [IO.Path]::GetFileName($Path)
    }

    function touch([string]$file) { "" | Out-File $file -Encoding utf8 }

    function what($s) {
        if ($null -eq $s) {
            return "null"
        }
        if ($s -is [string]) {
            # $alias = Get-Alias -Name $s -ErrorAction SilentlyContinue

            $cmd = Get-Command $s -ErrorAction SilentlyContinue
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
    Set-Alias type what

    function which($s) {
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
    Remove-Variable ErrorActionPreferenceOld
}

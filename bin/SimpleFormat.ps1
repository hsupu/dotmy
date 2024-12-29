<#
.SYNOPSIS
Simple template substitution

.NOTES
211108
#>
param(
    [Parameter(Mandatory, Position=0)]
    [string]$src,

    [Parameter(Mandatory, Position=1)]
    [string]$dst,

    [Parameter(Mandatory, Position=2)]
    [Hashtable]$map
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

# string[]
$in = Get-Content -Path $src -Encoding utf8

$out = [Text.StringBuilder]::new()

foreach ($line in $in) {
    $pos = 0
    while ($pos -lt $line.Length) {
        $nextStartPos = $line.IndexOf("{{", $pos, [StringComparison]::CurrentCultureIgnoreCase)
        if (-1 -eq $nextStartPos) {
            break
        }
        $nextEndPos = $line.IndexOf("}}", $nextStartPos + 2, [StringComparison]::CurrentCultureIgnoreCase)
        if (-1 -eq $nextEndPos) {
            break
        }

        $out.Append($line.Substring($pos, $nextStartPos - $pos)) | Out-Null

        $placeholder = $line.Substring($nextStartPos + 2, $nextEndPos - $nextStartPos - 2)
        Write-Host $placeholder
        $substitued = $map[$placeholder]
        $out.Append($substitued) | Out-Null
        $pos = $nextEndPos + 2
    }
    $out.Append($line.Substring($pos)).AppendLine() | Out-Null
}

$out = $out.ToString()
Set-Content -Path $dst -Value $out -Encoding utf8 | Out-Null

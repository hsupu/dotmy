
$Matches = [regex]::Matches($s, '^[^:]+: Blob:[0-9A-Z]+\r?$', [System.Text.RegularExpressions.RegexOptions]::Multiline)
if ($Matches.Count -gt 0) {
    echo 1
}
echo $Matches

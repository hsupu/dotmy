
function global:Dump-PwshDictionary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        $InputObject
    )
    begin {
        "@{"
    }
    process {
        # $escaped = $_.Value -replace '[*\\~;(%?.:@/]"', '`$&'
        $escaped = $_.Value -replace '''', '$&$&'
        "`t`"$($_.Key)`" = `'$escaped`';"
    }
    end {
        "}"
    }
}

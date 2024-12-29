
function global:git-root {
    & git rev-parse --show-toplevel
}

function global:git-basename {
    & git rev-parse --show-toplevel | % { [IO.Path]::GetFileName($_) }
}

function global:git-sha {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [AllowEmptyCollection()]
        [string[]]$Params
    )

    if (0 -eq $Params.Length) {
        $Params = @("HEAD")
    }
    # git show -s --format=%H
    & git rev-parse @Params
}

function global:git-head {
    git-sha --abbrev-ref HEAD @args
}

function global:git-commit {
    param(
        [Parameter(Position=0)]
        [string]$Message,

        [Parameter(ValueFromRemainingArguments)]
        [AllowEmptyCollection()]
        [string[]]$Params
    )

    if (([string]::IsNullOrEmpty($Message)) -and (0 -eq $Params.Length)) {
        $Params = @("-m", "update")
    }
    & git commit @Params
}


function git-root() {
    & git rev-parse --show-toplevel
}

function git-basename() {
    & git rev-parse --show-toplevel | %{ [IO.Path]::GetFileName($_) }
}

function git-sha() {
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

function git-head() {
    git-sha --abbrev-ref HEAD @args
}

function git-commit() {
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

function git-hint() {
    Write-Host "sha: git rev-parse --abbrev-ref HEAD"
    Write-Host "head: git rev-parse --abbrev-ref HEAD"
    Write-Host "root: git rev-parse --show-toplevel"
    Write-Host "sync: git fetch -p origin"
    Write-Host "bind: git branch --set-upstream origin/`$(git rev-parse --abbrev-ref HEAD)"
    Write-Host "push: git push origin `$(git rev-parse --abbrev-ref HEAD)"
    Write-Host "amend: git commit --amend --no-edit"
    Write-Host "reset-author: git rebase --root --exec `"git commit --amend --no-edit --reset-author`""
    Write-Host "orphan: git switch --orphan <new-branch>"
}

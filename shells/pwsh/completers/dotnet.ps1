# https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
#
try {
    if ($null -eq (Get-Command dotnet)) {
        throw
    }
}
catch {
    Write-Debug "dotnet not found, skip loading the completer"
    return
}

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    & dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

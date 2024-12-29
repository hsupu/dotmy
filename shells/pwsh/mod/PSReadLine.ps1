# PSReadLine config
#
# https://docs.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline?
# https://docs.microsoft.com/en-us/powershell/module/psreadline/set-psreadlineoption?
#
$module = Get-Module -Name "PSReadLine"
if (-not $module) {
    Write-Host "PSReadLine not installed"
    return
}
$version = $module.Version
if ($version.Major -gt 2) {
    # good
}
elseif ($version.Major -eq 2 -and $version.Minor -gt 1) {
    # good
}
else {
    Write-Host "PSReadLine outdated: $version < 2.2.0"
    return
}

#
# 配色
#

Set-PSReadLineOption -Colors @{
    "Parameter" = [System.ConsoleColor]::Magenta
    "Operator" = [System.ConsoleColor]::Magenta
}

#
# 键位基础
Set-PSReadLineOption -EditMode Windows

# 使用如下命令查看键位绑定
# Get-PSReadLineKeyHandler -Bound -Unbound
Remove-PSReadLineKeyHandler -Chord "Ctrl+Alt+?" # ShowKeyBindings

Set-PSReadLineKeyHandler -Chord "Escape" -Function Abort # RevertLine

#
# 编辑
#

# 撤销 重做
Set-PSReadLineKeyHandler -Chord "Ctrl+z" -Function Undo
Remove-PSReadLineKeyHandler -Chord "Ctrl+y" # Redo
Set-PSReadLineKeyHandler -Chord "Ctrl+Z" -Function Redo

# 字删除
# Set-PSReadLineKeyHandler -Chord "Backspace" -Function BackwardDeleteChar
Remove-PSReadLineKeyHandler -Chord "Ctrl+h" # BackwardDeleteChar
# Set-PSReadLineKeyHandler -Chord "Delete" -Function DeleteChar

# 词删除
Set-PSReadLineKeyHandler -Chord "Ctrl+Backspace" -Function BackwardDeleteWord # BackwardKillWord
Remove-PSReadLineKeyHandler -Chord "Ctrl+w" # BackwardKillWord
Set-PSReadLineKeyHandler -Chord "Ctrl+Delete" -Function DeleteEndOfWord # KillWord
Remove-PSReadLineKeyHandler -Chord "Alt+d" # KillWord

# 半行删除
# Set-PSReadLineKeyHandler -Chord "Ctrl+Home" -Function BackwardDeleteLine # BackwardDeleteInput
# Set-PSReadLineKeyHandler -Chord "Ctrl+End" -Function ForwardDeleteLine # ForwardDeleteInput
Remove-PSReadLineKeyHandler -Chord "Ctrl+Home"
Remove-PSReadLineKeyHandler -Chord "Ctrl+End"

# Kill/Yank
# Set-PSReadLineKeyHandler -Chord "Alt+Enter" -Function Yank
Remove-PSReadLineKeyHandler -Chord "Alt+." # YankLastArg

# 插入
Set-PSReadLineKeyHandler -Chord "Ctrl+Enter" -Function InsertLineBelow # InsertLineAbove
Set-PSReadLineKeyHandler -Chord "Ctrl+Shift+Enter" -Function InsertLineAbove # InsertLineBelow

#
# 导航 选区 翻页
#

# 词导航
# Set-PSReadLineKeyHandler -Chord "Ctrl+LeftArrow" -Function ShellBackwardWord # BackwardWord
# Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function ShellForwardWord # ForwardWord
Set-PSReadLineKeyHandler -Chord "Alt+b" -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Chord "Alt+f" -Function ShellForwardWord

# 行导航
Set-PSReadLineKeyHandler -Chord "Home" -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord "End" -Function EndOfLine
Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord "Ctrl+e" -Function EndOfLine

# 跳至配对的括号处
# 奇怪的是 Ctrl+[ 无法绑定
Set-PSReadLineKeyHandler -Chord "Ctrl+]" -Function GotoBrace

Set-PSReadLineKeyHandler -Chord "Shift+LeftArrow" -Function SelectBackwardChar
Set-PSReadLineKeyHandler -Chord "Ctrl+Shift+LeftArrow" -Function SelectShellBackwardWord

Set-PSReadLineKeyHandler -Chord "Shift+RightArrow" -Function SelectForwardChar
Set-PSReadLineKeyHandler -Chord "Ctrl+Shift+RightArrow" -Function SelectShellForwardWord

Set-PSReadLineKeyHandler -Chord "Shift+Home" -Function SelectBackwardChar
Set-PSReadLineKeyHandler -Chord "Shift+End" -Function SelectShellBackwardWord

# 上下翻页
# 虽然 Windows Terminal 也会模拟该效果，但 PowerShell 自身的上下翻页不可替代
# Remove-PSReadLineKeyHandler -Chord "PageUp" # ScrollDisplayUp
# Remove-PSReadLineKeyHandler -Chord "PageDown" # ScrollDisplayDown

# 上下翻行
Remove-PSReadLineKeyHandler -Chord "Ctrl+PageUp" # ScrollDisplayUpLine
Remove-PSReadLineKeyHandler -Chord "Ctrl+PageDown" # ScrollDisplayDownLine

Remove-PSReadLineKeyHandler -Chord "Ctrl+l" # ClearScreen

#
# 历史
# PSReadLine history 与 PowerShell built-in session history 是两回事
# https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/about/about_history?
#

$historyOptions = @{
    # HistoryNoDuplicates = $true;
    HistorySaveStyle = 'SaveIncrementally'; # 'SaveAtExit'
    HistorySearchCaseSensitive = $false;
    HistorySearchCursorMovesToEnd = $true;
}
Set-PSReadLineOption @historyOptions

# Set-PSReadLineKeyHandler -Chord Ctrl+s -Function ForwardSearchHistory # ForwardSearchHistory
# Set-PSReadLineKeyHandler -Chord Ctrl+r -Function ReverseSearchHistory # ReverseSearchHistory

Set-PSReadLineKeyHandler -Chord "UpArrow" -Function HistorySearchBackward # PreviousHistory
Set-PSReadLineKeyHandler -Chord "DownArrow" -Function HistorySearchForward # NextHistory
Set-PSReadLineKeyHandler -Chord "Shift+UpArrow" -Function PreviousHistory # unset
Set-PSReadLineKeyHandler -Chord "Shift+DownArrow" -Function NextHistory # unset

Remove-PSReadLineKeyHandler -Chord "F8" # HistorySearchBackward
Remove-PSReadLineKeyHandler -Chord "Shift+F8" # HistorySearchForward

Remove-PSReadLineKeyHandler -Chord "Alt+<" # BeginningOfHistory
Remove-PSReadLineKeyHandler -Chord "Alt+>" # EndOfHistory

Remove-PSReadLineKeyHandler -Chord "Alt+F7" # ClearHistory

#
# 补全
# https://docs.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline?#completion-functions
#

# -CompletionQueryItems 少于几项补全候选时不做二次确认
Set-PSReadLineOption `
    -CompletionQueryItems 128 `
    -ShowToolTips:$true

# https://docs.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline?#prediction-functions
Set-PSReadLineKeyHandler -Chord "Ctrl+Spacebar" -Function Complete # MenuComplete
Set-PSReadLineKeyHandler -Chord "Tab" -Function MenuComplete # TabCompleteNext
Remove-PSReadLineKeyHandler -Chord "Shift+Tab" # TabCompletePrevious
Set-PSReadLineKeyHandler -Chord "Alt+." -Function PossibleCompletions

#
# 预测建议
#

Set-PSReadLineOption `
    -PredictionSource HistoryAndPlugin `
    -PredictionViewStyle InlineView

Set-PSReadLineKeyHandler -Chord "Alt+UpArrow" -Function PreviousSuggestion
Set-PSReadLineKeyHandler -Chord "Alt+DownArrow" -Function NextSuggestion

Remove-PSReadLineKeyHandler -Chord "F2" # SwitchPredictionView

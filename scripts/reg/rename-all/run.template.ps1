
.\list.ps1 -Find "C:\my\local\app\vscode" -Root "HKEY_CLASSES_ROOT" -MatchKeyName -MatchEntryName -MatchEntryValue

.\rename.ps1 -Path ".\immediate.txt" -From "C:\my\local\app\vscode" -To "$env:LOCALAPPDATA\Programs\Microsoft VS Code"

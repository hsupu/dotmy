<#
.NOTES
数据存储在二进制文件中 %AppData%\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms
#>
param(
    [string]$AddPath,
    [string]$RemovePath
)

$ErrorActionPreference = "Stop"
trap { throw $_ }

$ShellApp = New-Object -ComObject "shell.application"
$DefaultFolders = @{
    "Desktop" = "shell:::{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}";
    "Documents" = "shell:::{d3162b92-9365-467a-956b-92703aca08af}";
    "Downloads" = "shell:::{088e3905-0323-4b02-9826-5d99428e115f}";
    "Frequent" = "shell:::{3936E9E4-D92C-4EEE-A85A-BC16D5EA0819}";
    # "Music" = "$($env:USERPROFILE)\Music";
    "Pictures" = "shell:::{24ad3ad4-a569-4530-98e1-ab02f9417aa8}";
    "QuickAccess" = "shell:::{679f85cb-0220-4080-b29b-5540cc05aab6}"
    "Recycle Bin" = "shell:::{645FF040-5081-101B-9F08-00AA002F954E}";
    "Videos" = "shell:::{A0953C92-50DC-43bf-BE83-3742FED03C9C}";
}


$Existing = $ShellApp.Namespace($DefaultFolders['Frequent']).Items()
$Existing | ForEach-Object { "$($_.Name) = $($_.Path)" }

if ('' -ne $RemovePath) {
    # $RemovePath = Resolve-Path -ErrorAction Stop -LiteralPath $RemovePath
    $Folder = $Existing | Where-Object { $_.Path -eq $RemovePath }
    $Folder
    $Folder.InvokeVerb("UnpinFromHome")
}

if ('' -ne $AddPath) {
    # $AddPath = Resolve-Path -ErrorAction Stop -LiteralPath $AddPath
    $Folder = $ShellApp.Namespace($AddPath)
    $Folder.Self.InvokeVerb("PinToHome")
}

<#
TODO
#>
param(
    [string]$NewPath
)

$map = @{
    "Desktop"       = "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
    "Documents"     = "{FDD39AD0-238F-46AF-ADB4-6C85480369C7}"
    "Downloads"     = "{374DE290-123F-4565-9164-39C4925E467B}"
    "Favorites"     = "{1777F761-68AD-4D8A-87BD-30B759FA33DD}"
    "Links"         = "{BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968}"
    "Music"         = "{4BD8D571-6D19-48D3-BE97-422220080E43}"
    "Pictures"      = "{33E28130-4E1E-4676-835A-98395C3BC3BB}"
    "Programs"      = "{A77F5D77-2E2B-44C3-A6A2-ABA601054A51}"
    "Recent"        = "{AE50C081-EBD2-438A-8655-8A092E34987A}"
    "Searches"      = "{7D1D3A04-DEBB-4115-95CF-2F29DA2920DA}"
    "SendTo"        = "{8983036C-27C0-404B-8F08-102D10DCFD74}"
    "Start Menu"    = "{625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}"
    "StartUp"       = "{B97D20BB-F46A-4C97-BA10-5E3608430854}"
    "Templates"     = "{A63293E8-664E-48DB-A079-DF759E0509F7}"
    "Videos"        = "{18989B1D-99B5-455B-841C-AB7C74E4DDFC}"
}

$newDownloadsPath = "D:\Downloads"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}" -Type String -Value $newDownloadsPath

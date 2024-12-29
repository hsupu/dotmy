
# No error is good

# since 7.3
if (([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("7.3")) -ge 0) {
    # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_calling_generic_methods?view=powershell-7.3
    # [System.Enum]::GetValues[System.IO.FileAttributes]() | Out-Null
}

# since 6
if (([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("6.0")) -ge 0) {
    # $m = [System.Enum].GetMethod("GetValues", 1, [System.Type[]]@())
    # $gm = $m.MakeGenericMethod([System.IO.FileAttributes])
    # $gm.Invoke($null, @()) | Out-Null
}

# powershell 5
# 这时的 dotnet 似乎还不支持 method<T>() 这种泛型不出现在参数中的写法？待确认

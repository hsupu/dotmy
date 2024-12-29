

$regKey = "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
$regNameMap = @{
	SkypeShare = "{776DBC8D-7347-478C-8D71-791E12EF49D8}";
	OneDriveAdd = "{CB3D0F55-BC2C-4C1A-85ED-23ED75B5106B}";
}

foreach ($kvp in $regNameMap.GetEnumerator()) {
    $desc = $kvp.Key
    $regName = $kvp.Value
    $regValue = Get-ItemPropertyValue -ErrorAction SilentlyContinue -Path $regKey -Name $regName
    if ($null -eq $regValue) {
        New-ItemProperty -ErrorAction Stop -Path $regKey -Name $regName -PropertyType String -Value ""
    }
    else {
        Set-ItemProperty -ErrorAction Stop -Path $regKey -Name $regName -PropertyType String -Value ""
    }
}

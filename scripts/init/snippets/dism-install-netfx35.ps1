
# Disable Local Windows Update Service
# HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU UseWUServer 0

# /Online : fetch from online source.
# /All : enable all parent features of the specified feature.
dism /online /enable-feature /featurename:NetFx3 /All

# /LimitAccess : prevent DISM from contacting Windows Update/WSUS.
# /Source : specify the location of the files that are needed to restore the feature.
# dism /online /enable-feature /featurename:NetFX3 /Source:H:\sources\sxs /LimitAccess
# dism /online /enable-feature /featurename:NetFX3 /Source:"%windir%" /LimitAccess

# Install local package
# dism.exe /online /add-package /packagepath:"C:\WINDOWS\netfx3.cab"

# Add-WindowsCapability -Online -Name NetFx3

# Install-WindowsFeature -Name "NET-Framework-Core" -Source "D:\temp\sxs"

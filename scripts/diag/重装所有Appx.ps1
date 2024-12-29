
Get-AppxPackage | % { Add-AppxPackage -Register -DisableDevelopmentMode "$($_.InstallLocation)\AppxManifest.xml" -Verbose }

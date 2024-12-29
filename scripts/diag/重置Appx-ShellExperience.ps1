param()

$ErrorActionPreference = 'Stop'
trap { throw $_ }

# win10
# Get-AppxPackage -All *ShellExperience* -PackageType Bundle | % { Add-AppxPackage -Register -DisableDevelopmentMode "$($_.InstallLocation)\AppxMetadata\AppxBundleManifest.xml" }

# win11
Get-AppxPackage -All *ShellExperience* | % { Add-AppxPackage -Register -DisableDevelopmentMode "$($_.InstallLocation)\AppxManifest.xml" }

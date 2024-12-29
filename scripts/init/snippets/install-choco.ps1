
# https://docs.chocolatey.org/en-us/choco/setup#more-install-options
$env:ChocolateyInstall = 'C:\opt\choco'
Set-ExecutionPolicy Bypass -Scope Process -Force
# TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# https://docs.chocolatey.org/en-us/configuration
choco feature disable showNonElevatedWarnings -y

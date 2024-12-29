param()

# $env:JAVA_HOME = Resolve-Path -ErrorAction Stop -LiteralPath (Join-Path $env:SCOOP "apps\temurin21-jdk\current")
$env:JAVA_HOME = & scoop prefix temurin21-jdk
$env:PATH = "$($env:JAVA_HOME);$($env:PATH)"

Push-Location $PSScriptRoot
try {
    & .\bin\startup.bat
}
finally {
    Pop-Location
}

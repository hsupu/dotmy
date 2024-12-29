param(
    [int]$Level = 0
)

# Ring0 - essential
#
if ($Level -lt 0) { return }

# for Windows
if (([string]$env:USERDNSDOMAIN).ToLower().EndsWith("microsoft.com")) {
    & winget install --source winget Microsoft.VisualStudio.2022.Enterprise
}
else {
    & winget install --source winget Microsoft.VisualStudio.2022.BuildTools
    & winget install --source winget Microsoft.VisualStudio.2022.Community
}

# CLI & TUI
& scoop install git-interactive-rebase-tool

# GUI
& scoop install dependencies
& winget instlal --source msstore 9PGCV4V3BK4W # DevToys

# Ring1 - basic
#
if ($Level -lt 1) { return }

& winget install --source winget Postman.Postman
& winget install --source winget GitHub.GitHubDesktop

# Ring2 - advanced
#
if ($Level -lt 2) { return }

# GUI
& winget install --source winget JetBrains.IntelliJIDEA.Ultimate
& winget install --source winget JetBrains.PyCharm.Professional
# & winget install --source winget JetBrains.RubyMine
# & winget install --source winget JetBrains.CLion

# CLI & TUI
& scoop install aws
& scoop install azcopy
& scoop install azure-cli
& scoop install broot
& scoop install nuget

# Ring3 - optional
#
if ($Level -lt 3) { return }

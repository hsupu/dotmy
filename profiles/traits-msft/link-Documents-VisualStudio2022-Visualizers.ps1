param()

function main {

    Get-ChildItem "$env:OneDriveCommercial\my\var\Visual Studio 2022\Visualizers\" -File | % { & cmd /c mklink $_.Name $_.FullName }
    Get-ChildItem "$env:DOTMY\programs\vs\Visualizers\" -File | % { & cmd /c mklink $_.Name $_.FullName }

}

Push-Location "$HOME\Documents\Visual Studio 2022\Visualizers\"
try {
    main
}
finally {
    Pop-Location
}

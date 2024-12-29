
$version = "v2.30.0"
$filename = "filebrowser-windows-amd64.zip"
& curl -O $filename "https://github.com/filebrowser/filebrowser/releases/download/$version/windows-amd64-filebrowser.zip"

Expand-Archive -LiteralPath $filename -DestinationPath .\tmp
Move-Item .\tmp\filebrowser.exe C:\my\local\bin\

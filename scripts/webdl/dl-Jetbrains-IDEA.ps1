$version = "2018.3"
$platform = "exe"

$filename = "ideaIU-$version.$platform"
Write-Output $filename

$uri = "https://download.jetbrains.com/idea/$filename"
$file = "$filename"

Invoke-WebRequest -Uri $uri -OutFile $file


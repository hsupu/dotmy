# run on WinServer powershell.exe

$user = Get-ADUser -Identity $env:USERNAME -Properties MemberOf

$computers = Get-ADComputer -Filter "Name -like `"xpu-*`"" `
    -SearchBase "OU=fareast,OU=corp,OU=microsoft,OU=com" `
    -Properties MemberOf `

Write-Host $computers

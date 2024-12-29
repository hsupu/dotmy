
$descs = @("NoNoNo", "Yes!")
$choices = @("&No", "&Yes")
$choice = $Host.UI.PromptForChoice("Title here", $descs, $choices, 0)
Write-Host $choice

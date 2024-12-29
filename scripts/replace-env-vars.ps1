param(
    [string]$Find,
    [string]$Replace,
    [switch]$DryRun
)

$Find = [regex]::Escape($Find)
# $Replace = [regex]::Escape($Replace)

function FindAndReplace() {
    param(
        [System.EnvironmentVariableTarget]$Target
    )
    $vars = [System.Environment]::GetEnvironmentVariables($Target)
    foreach ($kvp in $vars.GetEnumerator()) {
        $key = $kvp.Key
        $value = $kvp.Value
        if ($value -match $Find) {
            # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators
            $newValue = $value -ireplace $Find, $Replace
            Write-Host "$key : $value => $newValue"
            if ($DryRun) {
                continue
            }
            [System.Environment]::SetEnvironmentVariable($key, $newValue, $Target)
        }
    }
}

# FindAndReplace -Target 'Machine'
FindAndReplace -Target 'User'

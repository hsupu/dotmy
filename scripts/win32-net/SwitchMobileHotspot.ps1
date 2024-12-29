<#
.LINK
https://superuser.com/a/1434648
#>
param(
    [switch]$Start,
    [switch]$Stop,
    [switch]$AlwaysOn
)

[Windows.System.UserProfile.LockScreen,Windows.System.UserProfile,ContentType=WindowsRuntime] | Out-Null
Add-Type -AssemblyName System.Runtime.WindowsRuntime

# Ben N.'s await for WinRT IAsyncOperation:
# https://superuser.com/questions/1341997/using-a-uwp-api-namespace-in-powershell
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
$asTask = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and !$_.IsGenericMethod })[0]
function await($WinRtTask, $ResultType) {
    $asTaskT = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTaskT.Invoke($null, @($WinRtTask))
    $netTask.Wait(-1) | Out-Null
    $netTask.Result
}
function awaitAction($WinRtAction) {
    $netTask = $asTask.Invoke($null, @($WinRtAction))
    $netTask.Wait(-1) | Out-Null
}

$connectionProfile = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile()
$tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile)

# Check whether Mobile Hotspot is enabled
$enabled = $tetheringManager.TetheringOperationalState -eq 1 # or "Off"
$enabled

if ($Stop) {
    await ($tetheringManager.StopTetheringAsync())([Windows.Networking.NetworkOperators.NetworkOperatorTetheringOperationResult])
}

if ($Start) {
    await ($tetheringManager.StartTetheringAsync())([Windows.Networking.NetworkOperators.NetworkOperatorTetheringOperationResult])
}

if ($AlwaysOn) {
    $currentDateTime = Get-Date -Format "MM-dd-yyyy HH:mm:ss"
    "$currentDateTime Starting hotspot keep-alive."
    while ($true) {
        # Get the current date and time in a specific format
        $currentDateTime = Get-Date -Format "MM-dd-yyyy HH:mm:ss"
        if (Check_HotspotStatus) {
            "$currentDateTime Hotspot is off! Turning it on"
            Start_Hotspot
        }
        Start-Sleep -Seconds 10
    }
}

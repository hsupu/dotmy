
[Console]::TreatControlCAsInput = $true

Start-Sleep -Seconds 1
$Host.UI.RawUI.FlushInputBuffer()

while ($true) {
    # If a key was pressed during the loop execution, check to see if it was CTRL-C (aka "3"), and if so exit the script after clearing
    #   out any running jobs and setting CTRL-C back to normal.
    if ($Host.UI.RawUI.KeyAvailable -and ($Key = $Host.UI.RawUI.ReadKey("AllowCtrlC,NoEcho,IncludeKeyUp"))) {
        if ([int]$Key.Character -eq 3) {
            Write-Host ""
            Write-Warning "CTRL-C was used - Shutting down any running jobs before exiting the script."
            Get-Job | Where-Object { $_.Name -like "MessageProfile*" } | Remove-Job -Force -Confirm:$false
            [Console]::TreatControlCAsInput = $false
            _Exit-Script -HardExit $true
        }
        # Flush the key buffer again for the next loop.
        $Host.UI.RawUI.FlushInputBuffer()
    }
}

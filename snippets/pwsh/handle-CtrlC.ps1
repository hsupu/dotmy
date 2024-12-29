
[Console]::Add_CancelKeyPress({
    Write-Host "Ctrl+C"
    $proc.CloseMainWindow()
})

Register-ObjectEvent `
    -InputObject ([Console]) `
    -EventName "CancelKeyPress" `
    -SourceIdentifier "ConsoleCancelEventHandler" `
    -Action {
        Write-Host "Ctrl+C"
        # 注意，这里无法阻止 Ctrl+C 触发其他取消事件
    } `
    | Out-Null

[Console]::TreatControlCAsInput = $true

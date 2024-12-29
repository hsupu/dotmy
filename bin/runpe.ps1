
$ErrorActionPreference = 'Stop'
trap { throw $_ }

if ($args.Length -eq 0) {
    Write-Host "Usage: runpe <exe> [args...]"
    return
}

$exePath = $args[0]
if ($args.Length -eq 1) {
    $exeArgs = @()
}
else {
    $exeArgs = $args[1..($args.Length - 1)]
}

Start-Process -FilePath $exePath -ArgumentList $exeArgs -Wait -NoNewWindow -WorkingDirectory $PWD

return

$startInfo = [System.Diagnostics.ProcessStartInfo]::new()
$startInfo.FileName = $exePath
foreach ($arg in $exeArgs) {
    $startInfo.ArgumentList.Add($arg)
}
$startInfo.WorkingDirectory = $PWD
$startInfo.UseShellExecute = $false
$startInfo.CreateNoWindow = $true
# $startInfo.RedirectStandardInput = $true
# $startInfo.RedirectStandardOutput = $true
# $startInfo.RedirectStandardError = $true
# $startInfo.StandardInputEncoding = [System.Text.Encoding]::UTF8
# $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
# $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

function Run-PE {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Diagnostics.ProcessStartInfo]$StartInfo
    )
    begin {
    }
    process {
        $proc = [System.Diagnostics.Process]::Start($startInfo)
    }
    clean {

    }
}

[Console]::TreatControlCAsInput = $true
try {
    Start-Sleep -Seconds 1
    $Host.UI.RawUI.FlushInputBuffer()


    New-Event
    $proc.WaitForExit() | Out-Null
}
finally {
    [Console]::TreatControlCAsInput = $false
}

$proc.ExitCode
return

try {
    $eventJob = Register-ObjectEvent `
        -InputObject ([Console]) `
        -EventName "CancelKeyPress" `
        -MaxTriggerCount 1 `
        -MessageData $proc `
        -Action {
            Write-Host "Ctrl+C"
            $EventArgs.Cancel = $true
            # $proc = $event.MessageData
        }
    try {
        $proc.StandardInput.Close()

        $procJob = Start-ThreadJob -ScriptBlock {
            $proc = $input
            try {
                $proc.WaitForExit() | Out-Null
                $proc.ExitCode
            }
            catch {
                Write-Error -ErrorAction Continue $_
            }
        } -InputObject $proc

        try {
            try {
                Wait-Job -Job @($eventJob, $procJob) -Any | Out-Null
            }
            catch {
                Write-Error -ErrorAction Continue $_
            }
            finally {
                if ($procJob.State -eq "Completed") {
                    Write-Host "Job$($procJob.Id) Exited"
                    try {
                        $procJob | Receive-Job
                    }
                    catch {
                        Write-Error -ErrorAction Continue $_
                    }
                }
                else {
                    Write-Host "Job$($procJob.Id) Interrupted"
                    try {
                        if (-not $proc.CloseMainWindow()) {
                            Write-Host "CloseMainWindow failed"
                            $proc.Kill()
                            Write-Host "Killed"
                        }

                        if (-not $proc.HasExited) {
                            Write-Host "Waiting for exited in 3s.."
                            while (-not $proc.WaitForExit(3000)) {
                                $proc.Kill()
                                Write-Host "Killed"
                            }
                        }
                        Write-Host "Cleaned up"
                    }
                    catch {
                        Write-Error -ErrorAction Continue $_
                    }
                }
            }
        }
        finally {
            if (-not $proc.HasExited) {
                $proc.Kill()
                Write-Host "Killed"
            }
            $procJob | Stop-Job -PassThru | Remove-Job
        }
    }
    finally {
        $eventJob | Stop-Job -PassThru | Remove-Job
    }
}
finally {
    $proc.Close()
    # Write-Host "finally"
}

# try {
#     # $proc.BeginOutputReadLine()
#     # $proc.BeginErrorReadLine()
#     $proc.WaitForExit() | Out-Null
#     $proc.ExitCode
# }
# finally {
#     $proc.Close()
# }

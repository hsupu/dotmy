<#
.Synopsis
Exports environment variable from the .env file to the current process.

.Description
This function looks for .env file in the current directoty, if present
it loads the environment variable mentioned in the file to the current process.

.Example
Set-PsEnv

.Example
# .env file format
#
# To Assign value, use "=" operator
<variable name> = <value>
# To Prefix value to an existing env variable, use ":=" operator
<variable name> := <value>
# To Suffix value to an existing env variable, use "=:" operator
<variable name> =: <value>
# To comment a line, use "#" at the start of the line
# This is a comment, it will be skipped when parsing

.Example
# This is function is called by convention in PowerShell
# Auto exports the env variable at every prompt change
function prompt {
    Set-PsEnv
}
#>

function Set-PsEnv {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param()

    if ($global:DotEnvLastDir -eq (Get-Location).Path){
        return
    }
    $global:DotEnvLastDir = (Get-Location).Path

    $filename = ".\.env"
    if (Test-Path env:DOTENV_FILENAME) {
        $filename = $env:DOTENV_FILENAME
    }

    if (! (Test-Path $filename)) {
        Write-Verbose "`"$filename`" not found"
        return
    }

    $content = Get-Content $filename -ErrorAction Stop
    Write-Verbose "`"$filename`" loaded"

    #load the content to environment
    foreach ($line in $content) {

        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        if ($line.StartsWith("#")) {
            Write-Verbose "Skipping comment line: $line"
            continue
        }

        if ($line -like "*:=*") {
            $kvp = $line -split ":=", 2
            Write-Verbose "Prefix $($kvp[0])"

            $key = $kvp[0].Trim()
            $value = "{0};{1}" -f $kvp[1].Trim(), (Get-Item -LiteralPath env:$key)
        }
        elseif ($line -like "*=:*") {
            $kvp = $line -split "=:", 2
            Write-Verbose "Suffix $($kvp[0])"

            $key = $kvp[0].Trim()
            $value = "{1};{0}" -f $kvp[1].Trim(), (Get-Item -LiteralPath env:$key)
        }
        else {
            $kvp = $line -split "=",2
            Write-Verbose "Assign $($kvp[0])"

            $key = $kvp[0].Trim()
            $value = $kvp[1].Trim()
        }

        Write-Verbose "$key=$value"

        if ($PSCmdlet.ShouldProcess("environment variable $key", "set value $value")) {
            [Environment]::SetEnvironmentVariable($key, $value, [System.EnvironmentVariableTarget]::Process) | Out-Null
        }
    }
}

Export-ModuleMember -Function @('Set-PsEnv')

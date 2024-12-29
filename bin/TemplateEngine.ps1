<#
.SYNOPSIS
Yet another template engine for PowerShell

.DESCRIPTION
Forked and simplifized from https://github.com/straightdave/eps

Changes:
  Merge to single-file
  Rename some parameters
  Force use InvokeWithContext (remove -Safe too)
  Remove helper Each.ps1

Features:
  <% expression %> Invoke expression only
  <%= expression %> Invoke expression and print
  <%# comment %> Comment

Known Issues:
  Operators applied to ForEach-Object are ignored to internal output. e.g.
    ForEach-Object { <%= %> } -join ',`n'
#>
param()

$ErrorActionPreference = "Stop"
trap { throw $_ }

function Get-OrElse {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline, Position=0)]
        [Object]$Value,

        [Parameter(Mandatory, Position=1, ParameterSetName='Default')]
        [Object]$Default,

        [Parameter(Mandatory, ParameterSetName='Throw')]
        [switch]$Throw
    )
    if ([string]::IsNullOrEmpty($Value)) {
        if ($Throw) {
            throw 'Value was null in Get-OrElse'
        }
        $Default
    }
    else {
        $Value
    }
}

function TPT-GenScript {
    Param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String]$Template,

        [switch]$ThrowIfNoCandidate
    )
    $position = 0
    $Pattern = [regex]("(?sm)(?<lit><%%|%%>)|<%(?<ind>={1,2}|-|#)?(?<code>.*?)(?<tailch>[-=])?(?<!%)%>(?<rspace>[ \t]*\r?\n)?")
    $StringBuilder = [Text.StringBuilder]::new()

    function Add-Prolog {
        [void]$StringBuilder.`
            Append("`$sb = [Text.StringBuilder]::new()`n").`
            Append("[void]`$(`n")
    }

    function Add-String {
        Param([String]$Value)

        if ($Value) {
            $Value = $Value -replace '([`"$])', '`$1'
            [void]$StringBuilder.Append(";`$sb.Append(`"").Append($Value).Append("`");")
        }
    }

    function Add-LiteralString {
        Param([String[]]$Values)

        foreach ($Value in $Values) {
            [void]$StringBuilder.Append($Value)
        }
    }

    function Add-Expression {
        Param([String]$Value)

        $Value = if ($ThrowIfNoCandidate) {
           '$(' + $Value + ') | Get-OrElse -Throw'
        }
        else {
            $Value
        }

        [void]$StringBuilder.`
            Append("`$sb.Append(`"`$(").`
            Append($Value.Replace('""', '`"`"')).`
            Append(")`");")
    }

    function Add-Code {
        Param([String]$Value)

        [void]$StringBuilder.Append($Value)
    }

    function Add-Epilog {
        [void]$StringBuilder.Append("`n)`n`$sb.ToString()")
    }

    Add-Prolog
    $Pattern.Matches($Template) | ForEach-Object {
        $match = $_
        $contentLength = $match.Index - $position
        $content = $Template.Substring($position, $contentLength)
        $position = $match.Index + $match.Length
        $lit = $match.Groups["lit"]

        if ($lit.Success) {
            if ($contentLength -ne 0) {
                Add-String $content
            }
            switch ($lit.Value) {
                "<%%" {
                    Add-String "<%"
                }
                "%%>" {
                    Add-String "%>"
                }
            }
        }
        else {
            $ind = $match.Groups["ind"].Value
            $code = $match.Groups["code"].Value
            $tail = $match.Groups["tailch"].Value
            $rspace = $match.Groups["rspace"].Value

            if (($ind -ne '-') -and ($contentLength -ne 0)) {
                Add-String $content
            }
            else {
                Add-Code ";"
            }

            switch ($ind) {
                '=' {
                    Add-Expression $code.Trim()
                }
                '-' {
                    Add-String ($content -replace '(?smi)([\n\r]+|\A)[ \t]+\z', '$1')
                    Add-Code $code.Trim()
                }
                '' {
                    Add-Code $code.Trim()
                }
                '#' { # Do nothing
                }
            }

            if (($ind -ne '%') -and (($tail -ne '-') -or ($rspace -match '^[^\r\n]'))) {
                Add-String $rspace
            }
            else {
                Add-Code ";"
            }
        }
    }
    if ($position -eq 0) {
        Add-String $Template
    }
    elseif ($position -lt $Template.Length) {
        Add-String $Template.Substring($position, $Template.Length - $position)
    }
    Add-Epilog

    return $StringBuilder.ToString()
}

function TPT-Gen {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", "")]
    Param(
        [Parameter(Mandatory, ParameterSetName='StringTemplate')]
        [String]$Template,

        [Parameter(Mandatory, ParameterSetName='FileTemplate')]
        [String]$File,

        [Parameter(ValueFromPipeline, ValueFromPipelinebyPropertyName)]
        [Hashtable]$Binding = @{},

        [Hashtable]$Funcions = @{},

        [switch]$ThrowIfNoCandidate,

        [switch]$DebugScript
    )

    if ($PSCmdlet.ParameterSetName -eq 'FileTemplate') {
        $rootedPath = $File
        if (![IO.Path]::isPathRooted($rootedPath)) {
            $rootedPath = Join-Path (Get-Location) $rootedPath
        }

        $Template = [IO.File]::ReadAllText($rootedPath)
    }

    $templateScript = TPT-GenScript -Template $Template -ThrowIfNoCandidate:$ThrowIfNoCandidate
    if ($DebugScript) {
        Set-Content -Path "./tmp.ps1" -Value $templateScript
    }
    $templateScriptBlock = [ScriptBlock]::Create($templateScript)
    Write-Verbose "Executing script @'`n$templateScriptBlock`n'@."

    # InvokeWithContext was introduced in PowerShell version 3.0
    # see: https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.scriptblock.invokewithcontext?view=powershellsdk-1.1.0
    $variablesToDefine = $Binding.GetEnumerator() |
        ForEach-Object { New-Object System.Management.Automation.PSVariable @($_.Key, $_.Value) }
    $templateScriptBlock.InvokeWithContext($Funcions, $variablesToDefine)
}

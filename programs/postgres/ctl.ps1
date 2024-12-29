<#
.NOTES
Script Ver: 240717

.LINK
https://www.postgresql.org/docs/current/app-pg-ctl.html
#>
param(
    [string]$DataDir,
    [string]$Username,
    [switch]$InitDataDir,

    [string]$ServiceName,
    [switch]$RegisterService,
    [switch]$UnregisterService,

    [switch]$Start,
    [switch]$Stop,
    [switch]$AdhocInstance,

    [switch]$CreateDb,
    [string]$DbName,

    [string]$RunSql
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$pgctl = (Get-Command -ErrorAction Stop "pg_ctl.exe").Path
$psql = (Get-Command -ErrorAction Stop "psql.exe").Path

if ('' -eq $script:DataDir) {
    if (Test-Path -LiteralPath "C:\my\local\var\pgsql" -PathType Container) {
        $script:DataDir = "C:\my\local\var\pgsql"
    }
    else {
        $script:DataDir = Join-Path $PSScriptRoot "data"
    }
}

if ('' -eq $script:Username) {
    $script:Username = "postgres"
}

if ('' -eq $script:ServiceName) {
    $script:ServiceName = "PostgreSQL"
}

if ('' -eq $script:DbName) {
    $script:DbName = "main"
}

if ('' -ne $script:RunSql) {
    $script:RunSql = Resolve-Path -ErrorAction Stop -LiteralPath $script:RunSql
}

$env:LC_ALL = "en_US.UTF-8"

& $pgctl --version
if ($LASTEXITCODE -ne 0) {
    throw "pg_ctl exited with $LASTEXITCODE"
}

& $psql --version
if ($LASTEXITCODE -ne 0) {
    throw "psql exited with $LASTEXITCODE"
}

$script:currentUser = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()

function Test-IsAdmin {
    param(
        [switch]$NoThrow
    )
    $isAdmin = $script:currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin -and -not $NoThrow) {
        throw "Not run as Admin"
    }
}

function DoInitDataDir {
    Write-Host "pg_ctl initdb -D $script:DataDir"
    # postgresql.conf is at root of the data dir
    & $pgctl initdb -D $script:DataDir -o "--username=$script:Username --locale=en_US.UTF-8 --encoding=UTF8 --set config_file=.\postgresql.conf"
    if ($LASTEXITCODE -ne 0) {
        throw "pg_ctl initdb exited with $LASTEXITCODE"
    }
}

function DoRegisterService {
    Test-IsAdmin
    Write-Host "pg_ctl register -N $script:ServiceName"
    # -S - start type
    # -w - wait for server to start
    & $pgctl register -N $script:ServiceName -D $script:DataDir -l postgres.log -U LocalSystem -S auto --wait
    if ($LASTEXITCODE -ne 0) {
        throw "pg_ctl register exited with $LASTEXITCODE"
    }
    Get-Service -ErrorAction Stop -Name $script:ServiceName
    Set-Service -ErrorAction Stop -Name $script:ServiceName -StartupType Manual
}

function DoUnregisterService {
    Test-IsAdmin
    Stop-Service -ErrorAction Stop -Name $script:ServiceName
    Write-Host "pg_ctl unregister -N $script:ServiceName"
    & $pgctl unregister -N $script:ServiceName
    if ($LASTEXITCODE -ne 0) {
        throw "pg_ctl unregister exited with $LASTEXITCODE"
    }
    $svc = Get-Service -ErrorAction SilentlyContinue -Name $script:ServiceName
    if ($null -ne $svc) {
        throw "Service $script:ServiceName still exists"
    }
}

function DoStartService {
    Test-IsAdmin
    Start-Service -ErrorAction Stop -Name $script:ServiceName
    Get-Service -ErrorAction Stop -Name $script:ServiceName
}

function DoStopService {
    Test-IsAdmin
    Stop-Service -ErrorAction Stop -Name $script:ServiceName
    Get-Service -ErrorAction Stop -Name $script:ServiceName
}

function DoStartInstance {
    Write-Host "pg_ctl start -D $script:DataDir"
    & $pgctl start -D $script:DataDir
    if ($LASTEXITCODE -ne 0) {
        throw "pg_ctl start exited with $LASTEXITCODE"
    }
}

function DoStopInstance {
    Write-Host "pg_ctl stop -D $script:DataDir"
    & $pgctl stop -D $script:DataDir
    if ($LASTEXITCODE -ne 0) {
        throw "pg_ctl stop exited with $LASTEXITCODE"
    }
}

function DoCreateDb {
    # 自带输出
    & $psql -U $script:Username -c "CREATE DATABASE $script:DbName WITH OWNER $script:Username ENCODING 'utf-8';"
    if ($LASTEXITCODE -ne 0) {
        throw "psql exited with $LASTEXITCODE"
    }
}

function DoRunSql {
    & $psql -U $script:Username -d $script:DbName -f $script:RunSql
    if ($LASTEXITCODE -ne 0) {
        throw "psql exited with $LASTEXITCODE"
    }
}

function main {
    if ($Stop) {
        if ($AdhocInstance) {
            DoStopInstance
        }
        else {
            DoStopService
        }
    }

    if ($UnregisterService) {
        DoUnregisterService
    }

    if ($InitDataDir) {
        DoInitDataDir
    }

    if ($RegisterService) {
        DoRegisterService
    }

    if ($Start) {
        if ($AdhocInstance) {
            DoStartInstance
        }
        else {
            DoStartService
        }
    }

    if ($CreateDb) {
        DoCreateDb
    }

    if ('' -ne $RunSql) {
        DoRunSql
    }
}

main

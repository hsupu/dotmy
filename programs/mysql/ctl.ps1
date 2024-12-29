<#
.NOTES
Script Ver: 240717
#>
param(
    [switch]$InitDataDir,

    [string]$ServiceName,
    [switch]$RegisterService,
    [switch]$UnregisterService,

    [switch]$Start,
    [switch]$Stop,
    [switch]$AdhocInstance,

    [switch]$CreateDb,
    [string]$DbName,

    [switch]$Test
)

trap { throw $_ }
$mysqladmin = (Get-Command -ErrorAction Stop "mysqladmin.exe").Path
$mysqld = (Get-Command -ErrorAction Stop "mysqld.exe").Path
$mysqlshow = (Get-Command -ErrorAction Stop "mysqlshow.exe").Path

# MySQL my.ini 独立于 data 文件夹
$script:optfile = Resolve-Path (Join-Path $PSScriptRoot "my-opts.$(& hostname).cnf")

$script:Username = "root"

if ('' -eq $script:ServiceName) {
    $script:ServiceName = "MySQL"
}

& $mysqld --version
if ($LASTEXITCODE -ne 0) {
    throw "mysqld exited with $LASTEXITCODE"
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
    $DataDir = Join-Path $PSScriptRoot "data"
    if (Test-Path (Join-Path $script:DataDir "auto.cnf")) {
        Write-Host "Data directory already initialized"
        return
    }

    Write-Host "Initializing database..."
    & $mysqld --defaults-file="$script:optfile" --initialize-insecure --console --user=$script:Username
    if ($LASTEXITCODE -ne 0) {
        throw "mysqld exited with $LASTEXITCODE"
    }
    Write-Warning -WarningAction Continue 'Database initialized with username=root password=<blank>'
}

function DoRegisterService {
    Test-IsAdmin
    Write-Host "mysqld --install-manual"
    # use --install if want to auto-start
    # --local-service : use restricted account "NT AUTHORITY\LocalService"
    & $mysqld --install-manual $script:ServiceName --defaults-file="$script:optfile" --local-service
    if ($LASTEXITCODE -ne 0) {
        throw "mysqld exited with $LASTEXITCODE"
    }
    Get-Service -ErrorAction Stop -Name $script:ServiceName
}

function DoUnregisterService {
    <#
    .NOTES
    (Remove-Service -ErrorAction Stop -Name $script:ServiceName) works too
    #>
    Test-IsAdmin
    Stop-Service -ErrorAction Stop -Name $script:ServiceName
    Write-Host "mysqld --remove"
    & $mysqld --remove $script:ServiceName
    if ($LASTEXITCODE -ne 0) {
        throw "mysqld exited with $LASTEXITCODE"
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
    <#
    .LINK
    https://dev.mysql.com/doc/refman/9.0/en/windows-server-first-start.html
    https://dev.mysql.com/doc/refman/9.0/en/windows-start-command-line.html
    #>
    Test-IsAdmin
    # --console : print logs on console
    & $mysqld --defaults-file="$script:optfile" --console --standalone
    if ($LASTEXITCODE -ne 0) {
        throw "mysqld exited with $LASTEXITCODE"
    }
}

function DoStopInstance {
    Test-IsAdmin
    # add -p if has password
    & $mysqladmin --user=$script:Username shutdown
    if ($LASTEXITCODE -ne 0) {
        throw "mysqld exited with $LASTEXITCODE"
    }
}

function DoTest {
    & $mysqlshow -u $script:Username
    if ($LASTEXITCODE -ne 0) {
        throw "mysqlshow exited with $LASTEXITCODE"
    }

    & $mysqladmin -u $script:Username version status proc
    if ($LASTEXITCODE -ne 0) {
        throw "mysqladmin exited with $LASTEXITCODE"
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

    if ($Test) {
        DoTest
    }
}

main

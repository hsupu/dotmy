param()

pushd "$PSScriptRoot\"
try {
    $mysqld = "mysql-8.0.27-winx64\bin\mysqld.exe"
    $mysqldArgs = @(
        "--datadir=C:/my/local/dev/var/mysql/db",
        "--user=root",
        "--initialize-insecure",
        "--explicit_defaults_for_timestamp",
        "--verbose"
    )
    & $mysqld @mysqldArgs
}
finally {
    popd
}

param()

$mongoRoot = "$PSScriptRoot/mongodb-win32-x86_64-windows-5.0.3";
$mongoCfg = "C:/my/local/dev/var/mongo/mongod.cfg";

pushd "$PSScriptRoot/var/"
try {
    & "$mongoRoot/bin/mongod.exe" @(
        "-f", $mongoCfg
    )
}
finally {
    popd
}

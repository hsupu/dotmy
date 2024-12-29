
$kafkaRoot = & scoop prefix kafka
if (-not (Test-Path $kafkaRoot)) {
    Write-Error -ErrorAction Stop "scoop prefix kafka failed. Not installed?"
}

$kafkaProperties = Join-Path $PSScriptRoot "server.properties"
if (-not (Test-Path $kafkaProperties)) {
    $src = Resolve-Path -ErrorAction Stop (Join-Path $kafkaRoot "config\server.properties")
    Copy-Item -Path $src -Destination $kafkaProperties
}
$kafkaProperties = Resolve-Path -ErrorAction Stop $kafkaProperties

$kraftProperties = Join-Path $PSScriptRoot "kraft\server.properties"
if (-not (Test-Path $kraftProperties)) {
    $src = Resolve-Path -ErrorAction Stop (Join-Path $kafkaRoot "config\kraft\server.properties")
    Copy-Item -Path $src -Destination $kraftProperties
}
$kraftProperties = Resolve-Path -ErrorAction Stop $kraftProperties

Push-Location $kafkaRoot
try {
    $KAFKA_CLUSTER_ID = & .\bin\windows\kafka-storage random-uuid
    & .\bin\windows\kafka-storage format -t $KAFKA_CLUSTER_ID -c $kafkaProperties
    & .\bin\windows\kafka-server-start $kraftProperties
}
finally {
    Pop-Location
}

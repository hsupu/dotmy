param()

$env:JAVA_HOME = "C:\Program Files\Eclipse Foundation\jdk-17.0.0.35-hotspot\"
$env:KAFKA_HOME = "C:\my\local\dev\kafka_2.13-3.0.0"

pushd $env:KAFKA_HOME

.\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties
.\bin\windows\kafka-server-start.bat .\config\server.properties

popd

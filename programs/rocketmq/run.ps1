param()

$env:JAVA_HOME = "C:\Program Files\Eclipse Foundation\jdk-17.0.0.35-hotspot\"
$env:ROCKETMQ_HOME = "C:\my\local\dev\rocketmq-all-4.9.1-bin-release"
$env:NAMESRV_ADDR = "localhost:9876"

pushd $env:ROCKETMQ_HOME

& .\bin\mqnamesrv.cmd
& .\bin\mqbroker.cmd -n localhost:9876 autoCreateTopicEnable=true

popd

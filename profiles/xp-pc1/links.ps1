
pushd C:\
cmd /c mklink /d cache D:\cache

pushd C:\my
cmd /c mklink /d ws D:\ws

pushd C:\my\local
cmd /c mklink /d app D:\app\installed
cmd /c mklink /d portable D:\app\portable
cmd /c mklink /d srv D:\app\services

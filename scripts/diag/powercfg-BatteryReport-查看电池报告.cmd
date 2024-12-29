@echo off
powercfg /BatteryReport

@REM 尝试找到生成的位置
set me=%cd%
set html=%userprofile%\BatteryReport.html
if exist c:\windows\system32\battery-report.html (move /y c:\windows\system32\battery-report.html %html%) else (
	if exist %userprofile%\battery-report.html (move /y %userprofile%\battery-report.html %html%) else (
		if exist %me%\battery-report.html (move /y %me%\battery-report.html %html%) else (
			cmd
		)
	)
)

@REM 打开它
start %html%
exit

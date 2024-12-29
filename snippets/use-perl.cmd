@echo off
setlocal
perl -x %~f0 %*
endlocal
goto :EOF
#!perl

use strict;

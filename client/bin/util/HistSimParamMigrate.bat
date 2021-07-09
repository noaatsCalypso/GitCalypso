@echo off
setlocal

if "%1"=="" goto :USAGE
if "%2"=="" goto :USAGE
if "%3"=="" goto :USAGE
if "%4"=="" goto :USAGE
if "%5"=="" goto :USAGE
if "%6"=="" goto :USAGE

@echo About to transfer data to ers_an_param
SET /P ASK_CONTINUE=Continue (y/n)?
if /I %ASK_CONTINUE%==Y goto :MIGRATE

@echo Transfer canceled
goto :EOF

rem =======================================
:MIGRATE
set base=%~n0%~x0
echo %base%: Starting ERS Batch....

set ERS_HOME=
if not defined ERS_HOME= set ERS_HOME=%~dp0STOPPER
set ERS_HOME=%ERS_HOME:\bin\util\STOPPER=%

echo ERS_HOME: %ERS_HOME%

call %ERS_HOME%\bin\calypso_ers.bat


java com.calypso.tk.risk.HistSimParamLoader %1 %2 %3 %4 %5 %6 %7 %8

goto :EOF

rem ====================================================================================
:USAGE
@echo.
@echo Usage : %0 -env ^<calypso_env^>  -user ^<calypso_user^> -password ^<calypsopwd^> 
@echo.
@echo eg %0 -env Rel900 -user calypso_user -password calypso
@echo.
goto :EOF
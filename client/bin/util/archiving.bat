setlocal
set ERS_HOME=
if not defined ERS_HOME= set ERS_HOME=%~dp0STOPPER
set ERS_HOME=%ERS_HOME:\bin\util\STOPPER=%
echo ERS_HOME: %ERS_HOME%
pause
call %ERS_HOME%\bin\calypso_ers.bat
REM ## Can optional supply a "-valuedate" option to specify a valuation date other than today
java com.calypso.engine.risk.util.DailyArchiving %1 %2 %3 %4 %5 %6 %7 %8

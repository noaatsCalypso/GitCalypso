@echo off
setlocal EnableDelayedExpansion

set CALYPSO_HOME=..\..
set CURRENT_PARAMETER=
set _GRADLE_HOME=..\..\tools\gradle

for %%x in (%*) do (
   IF "!CURRENT_PARAMETER!"=="-PcalypsoHome" set CALYPSO_HOME=%%x
   IF "!CURRENT_PARAMETER!"=="-PgradleHome" set _GRADLE_HOME=%%x

   set CURRENT_PARAMETER=%%x

   IF "!CURRENT_PARAMETER:~0,14!"=="-PcalypsoHome=" set CALYPSO_HOME=!CURRENT_PARAMETER:~14!
   IF "!CURRENT_PARAMETER:~0,13!"=="-PgradleHome=" set _GRADLE_HOME=!CURRENT_PARAMETER:~13!
)

call %_GRADLE_HOME%\bin\gradle.bat %*

endlocal

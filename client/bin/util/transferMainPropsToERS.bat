setlocal
set ERS_HOME=
if not defined ERS_HOME= set ERS_HOME=%~dp0STOPPER
set ERS_HOME=%ERS_HOME:\bin\util\STOPPER=%
echo ERS_HOME: %ERS_HOME%

call %ERS_HOME%\bin\calypso_ers.bat
java com.calypso.tk.util.ERSDefaults %1 %2 %3 %4 %5 %6 %7 %8
goto :EOF

rem ====================================================================================
:USAGE
@echo.
@echo Usage : %0 -env ^<calypso_env^>  -user ^<calypso_user^> -password ^<calypsopwd^> 
@echo.
@echo eg %0 -env Rel900 -user calypso_user -password calypso
@echo.
goto :EOF
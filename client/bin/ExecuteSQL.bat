@echo off
SETLOCAL

rem To add comments to this script, please use rem
rem Comments with double : will be treated as help text

IF "X%1"=="X/?" GOTO Help

cd /d %~dp0

title ExecuteSQL

SET JAVA_OPTS=%JAVA_OPTS%

:: -env <CALYPSO_ENV>
::     To supply the name of the Env in which you wish to run.
:: 
:: -log
::     To log all tracing to a file in your USER_HOME/Calypso directory.
:: 
:: -user <USERNAME>
::     To supply the name of the Calypso user.
:: 
:: -password <PASSWORD>
::     To supply Calypso user's password.
:: 
:: -nogui
::     To run the application at the command line only, with no graphical user interface (GUI).
:: 
:: -logprefix <FILENAME>
::     To log all tracing to the file specified in the file_name argument. The file name can be a 
::     complete path name. The application will create the file; it need not already exist. Use 
::     this instead of the -log argument if you want to specify the path and file name. 
:: 
:: -userhome <DIRECTORY>
::     To set your default directory.
:: 
:: -logdir <DIRECTORY>
::     To specify the directory for logs.
:: 
:: -dbuser <DB_USERNAME>
::     Database user name, different from application user name.
:: 
:: -dbpassword <DB_PASSWORD>
::     Database user password, different from application password.
:: 

calypso.bat com.calypso.apps.startup.StartExecuteSQL -log %*

GOTO:EndScript

:Help
SETLOCAL ENABLEDELAYEDEXPANSION
for /f "tokens=*" %%n in ('findstr :: %0 ^| findstr /v findstr') do (
        SET HELPLINE=%%n
        if "!HELPLINE:~3!"=="" echo.
        if not "!HELPLINE:~3!"=="" echo !HELPLINE:~3!
)

GOTO:eof

:EndScript

ENDLOCAL

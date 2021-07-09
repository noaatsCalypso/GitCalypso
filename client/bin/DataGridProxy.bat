@echo off
SETLOCAL

rem To add comments to this script, please use rem
rem Comments with double : will be treated as help text

REM Multiple instance of GridProxy need to be started this could be a 1:5 ratio of DataGridProxy:DataGridNode
REM When starting proxy the tangosol.coherence.extend.address and tangosol.coherence.extend.port need to set to a host and name of the local machine. 
REM export JAVA_OPTS="-Xmx2g -Xms2g -Djava.security.egd=file:/dev/../dev/urandom -Ddatagrid.impl=coherence -Dcom.sun.management.jmxremote -Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true  -Dtangosol.coherence.clusteraddress=225.2.3.0 -Dtangosol.coherence.clusterport=9566 -Dtangosol.coherence.extend.address=localhost -Dtangosol.coherence.extend.port=7088 -Dtangosol.coherence.management.report.autostart=false"


IF "X%1"=="X/?" GOTO Help

cd /d %~dp0

title DataGridProxy

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


calypso.bat com.calypso.apps.startup.StartGridProxy -env @CALYPSO_ENV@ -log %*

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
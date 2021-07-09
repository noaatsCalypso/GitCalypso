setlocal

if "%CALYPSO_HOME%" == "" set CALYPSO_HOME=c:\calypso\software\rel800

set ERS_HOME=
if not defined ERS_HOME= set ERS_HOME=%~dp0STOPPER
set ERS_HOME=%ERS_HOME:\bin\util\STOPPER=%

set CALYPSO_LIB=%CALYPSO_HOME%\jars
set JAXB_LIB=%CALYPSO_LIB%\jaxb-1.0.4

set JAXB_JARS=^
%JAXB_LIB%\jaxb-api.jar;^
%JAXB_LIB%\jaxb-impl.jar;^
%JAXB_LIB%\jaxb-libs.jar;^
%JAXB_LIB%\jax-qname.jar;^
%JAXB_LIB%\namespace.jar;^
%JAXB_LIB%\relaxngDatatype.jar;^
%JAXB_LIB%\xsdlib.jar;^
%CALYPSO_LIB%\jaxb_impl_runtime.jar;^
%CALYPSO_LIB%\swift-xml_jaxb.jar

REM So this script can work internally as well
REM does not matter if this batch file is not in this location
call %CALYPSO_HOME%\bin\calypso.bat

set CLASSPATH=^
%ERS_HOME%\install\executesql\executesql.jar;^
%ERS_HOME%\install\executesql\schemer.jar;^
%ERS_HOME%\install\executesql\schemer_jaxb.jar;^
%CALYPSO_LIB%\calypso.jar;^
%CALYPSO_LIB%\jconn2.jar;^
%CALYPSO_LIB%\jconn3.jar;^
%CALYPSO_LIB%\ojdbc14.jar;^
%CALYPSO_HOME%;^
%JAXB_JARS%;^
%CLASSPATH%

set arg1=%1
set arg2=%2
set arg3=%3
set arg4=%4
set arg5=%5
set arg6=%6
set arg7=%7
set arg8=%8
set arg9=%9

set JAVAEXE=javaw
set P=start
if /I "%2" EQU "/d" set JAVAEXE=java
if /I "%2" EQU "/d" set P=start cmd /c
if /I "%2" EQU "/d" set arg2=
REM if /I "%2" EQU "/d" shift

if /I "%2" EQU "/k" set P=start cmd /K
if /I "%2" EQU "/k" set arg2=

if /I "%3" EQU "/k" set P=start cmd /K
if /I "%3" EQU "/k" set arg3=

if /I "%4" EQU "/k" set P=start cmd /K
if /I "%4" EQU "/k" set arg4=

if /I "%5" EQU "/k" set P=start cmd /K
if /I "%5" EQU "/k" set arg5=

if /I "%6" EQU "/k" set P=start cmd /K
if /I "%6" EQU "/k" set arg6=


	
if /I "%2" EQU "-nogui" set P=
if /I "%2" EQU "-nogui" set JAVAEXE=javaw

if /I "%3" EQU "-nogui" set P=
if /I "%3" EQU "-nogui" set JAVAEXE=javaw

if /I "%4" EQU "-nogui" set P=
if /I "%4" EQU "-nogui" set JAVAEXE=javaw

if /I "%5" EQU "-nogui" set P=
if /I "%5" EQU "-nogui" set JAVAEXE=javaw

if /I "%6" EQU "-nogui" set P=
if /I "%6" EQU "-nogui" set JAVAEXE=javaw

%P% %JAVAEXE% -Xmx128m  -Dsun.rmi.transport.tcp.handshakeTimeout=1200000 -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 com.calypso.apps.startup.StartExecuteSQL %arg1% %arg2% %arg3% %arg4% %arg5% %arg6% %arg7%  %arg8%  %arg9%
endlocal

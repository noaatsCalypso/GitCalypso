setlocal
set CALYPSO_HOME=c:\calypso\software\release

call %CALYPSO_HOME%\bin\calypso.bat
set CLASSPATH=ers-dbexport.jar;%CLASSPATH%

java -cp %CLASSPATH% com.calypso.risk.util.ImportExporter -env releaseNan -from result_history -o c:\tmp\ers_result.xml -where value_date=14525
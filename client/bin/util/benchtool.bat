setlocal
set CALYPSO_HOME=c:\calypso\software\rel900
set CLASSPATH=%CALYPSO_HOME%\build;%CALYPSO_HOME%\jars\calypsoCustom.jar;%CALYPSO_HOME%\patch\calypsoPatch.jar;%CALYPSO_HOME%\jars\calypso.jar;%CALYPSO_HOME%\resources;.;%CALYPSO_HOME%;%CALYPSO_HOME%\jars\jconn2.jar;%CALYPSO_HOME%\jars\jaxb.zip;%CALYPSO_HOME%\jars\javacup.jar;%CALYPSO_HOME%\jars\ojdbc14.jar;%CALYPSO_HOME%\jars\web\servlet.jar;%CALYPSO_HOME%\jars\web\webserver.jar;%CALYPSO_HOME%\jars\ftp.jar;%CALYPSO_HOME%\jars\itext-1.02b.jar;%CALYPSO_HOME%\jars\Jama-1.0.1.jar;%CALYPSO_HOME%\jars\jzlib.jar;%CLASSPATH%
REM It takes two arguments: 1. envName; 2. TradeId
%ERS_HOME%\test\groovy-1.0-jsr-04\bin\groovy %ERS_HOME%\bin\util\benchtool.groovy %1 %2 %3 %4 %5


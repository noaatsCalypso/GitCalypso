setlocal
set CALYPSO_HOME=c:\calypso\software\rel900
set CLASSPATH=%CALYPSO_HOME%\build;%CALYPSO_HOME%\jars\calypsoCustom.jar;%CALYPSO_HOME%\patch\calypsoPatch.jar;%CALYPSO_HOME%\jars\calypso.jar;%CALYPSO_HOME%\resources;.;%CALYPSO_HOME%;%CALYPSO_HOME%\jars\jconn2.jar;%CALYPSO_HOME%\jars\jaxb.zip;%CALYPSO_HOME%\jars\javacup.jar;%CALYPSO_HOME%\jars\ojdbc14.jar;%CALYPSO_HOME%\jars\web\servlet.jar;%CALYPSO_HOME%\jars\web\webserver.jar;%CALYPSO_HOME%\jars\ftp.jar;%CALYPSO_HOME%\jars\itext-1.02b.jar;%CALYPSO_HOME%\jars\Jama-1.0.1.jar;%CALYPSO_HOME%\jars\jzlib.jar;%CLASSPATH%
%GROOVY_HOME%\bin\groovy %ERS_HOME%\bin\util\EngineLog.groovy %COMPUTERNAME% %1 %2 %3 %4 %5 %6

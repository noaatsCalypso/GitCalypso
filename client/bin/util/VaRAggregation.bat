setlocal

SET ERS_SERVICE_HOME=%ERS_HOME%\services\webapps\risk-services\WEB-INF
SET CLASSPATH=%ERS_SERVICE_HOME%\lib\log4j-1.2.8.jar;%ERS_SERVICE_HOME%\lib\commons-logging-1.0.4.jar;%ERS_SERVICE_HOME%\lib\xom-1.1.jar;%ERS_SERVICE_HOME%\lib\xp.jar;%CLASSPATH%
SET CLASSPATH=%ERS_SERVICE_HOME%\lib\commons-math-1.0.jar;%ERS_SERVICE_HOME%\lib\ers-calypso_riskshared.jar;%CLASSPATH%
set CLASSPATH=%ERS_SERVICE_HOME%\classes;%CALYPSO_HOME%\build;%CALYPSO_HOME%\jars\calypsoCustom.jar;%CALYPSO_HOME%\patch\calypsoPatch.jar;%CALYPSO_HOME%\jars\calypso.jar;%CALYPSO_HOME%\resources;.;%CALYPSO_HOME%;%CALYPSO_HOME%\jars\jconn2.jar;%CALYPSO_HOME%\jars\jaxb.zip;%CALYPSO_HOME%\jars\javacup.jar;%CALYPSO_HOME%\jars\ojdbc14.jar;%CALYPSO_HOME%\jars\web\servlet.jar;%CALYPSO_HOME%\jars\web\webserver.jar;%CALYPSO_HOME%\jars\ftp.jar;%CALYPSO_HOME%\jars\itext-1.02b.jar;%CALYPSO_HOME%\jars\Jama-1.0.1.jar;%CALYPSO_HOME%\jars\jzlib.jar;%CLASSPATH%

%GROOVY_HOME%\bin\groovy %ERS_HOME%\bin\VaRAggregate.groovy %1 %2 %3 %4 %5 %6

endlocal

set GROOVY_HOME=%ERS_HOME%\test_utilities\groovy-1.0-jsr-05
rem set GROOVY_HOME=%ERS_HOME%\bin\util\groovy-1.0-jsr-05
set CLASSPATH=%GROOVY_HOME%\lib\antlr-2.7.5.jar;%ERS_HOME%\jars\commons-logging-1.0.4.jar;%ERS_HOME%\jars\log4j-1.2.8.jar;%CLASSPATH%
%GROOVY_HOME%\bin\groovy %1 %2 %3 %4 %5 %6 %7 %8 %9

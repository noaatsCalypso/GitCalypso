setlocal
call %ERS_HOME%\bin\calypso_ers.bat
SET CLASSPATH=%ERS_HOME%\modules\scenariogenerator\build;%CLASSPATH%
SET HIBERNATEPATH=%HIBERNATEPATH%;%GROOVY_HOME%\lib\asm-2.2.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%GROOVY_HOME%\lib\asm-attrs-2.2.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%GROOVY_HOME%\lib\antlr-2.7.5.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%ERS_HOME%\modules\scenariogenerator\jars\cglib-2.1.3.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%ERS_HOME%\modules\scenariogenerator\jars\commons-collections-2.1.1.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%ERS_HOME%\modules\scenariogenerator\jars\concurrent-1.3.2.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%ERS_HOME%\modules\scenariogenerator\jars\dom4j-1.6.1.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%ERS_HOME%\modules\scenariogenerator\jars\hibernate3.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%ERS_HOME%\modules\scenariogenerator\jars\jta.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%ERS_HOME%\modules\scenariogenerator\jars\ers-calypso_scenariogen.jar
SET HIBERNATEPATH=%HIBERNATEPATH%;%ERS_HOME%\modules\scenariogenerator\jars
SET CLASSPATH=%CLASSPATH%;%HIBERNATEPATH%

call %ERS_HOME%\bin\util\invokegroovy %ERS_HOME%\bin\util\scenariogen.groovy %1 %2 %3 %4 %5 %6

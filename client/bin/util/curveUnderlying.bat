setlocal
call %ERS_HOME%\bin\calypso_ers.bat
%GROOVY_HOME%\bin\groovy %ERS_HOME%\bin\util\curveunderlying.groovy %1 %2 %3 %4 %5

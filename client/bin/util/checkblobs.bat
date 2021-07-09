setlocal
call %ERS_HOME%\bin\calypso_ers.bat
call %ERS_HOME%\bin\util\invokegroovy %ERS_HOME%\bin\util\CheckBlobs.groovy %1 %2 %3 %4 %5 %6

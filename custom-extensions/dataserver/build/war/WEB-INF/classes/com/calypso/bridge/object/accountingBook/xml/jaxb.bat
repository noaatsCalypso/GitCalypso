cd ../../../../../../

%JAVA_HOME%\bin\java.exe -jar %JAXB_HOME%\lib\jaxb-xjc.jar -d . -extension -use-runtime com.calypso.tk.util.xml.impl.runtime com/calypso/bridge/object/accountingBook/xml/accountingBook.xsd

pause;
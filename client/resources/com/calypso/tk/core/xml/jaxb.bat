cd ../../../../..

%JAVA_HOME%\bin\java.exe -jar %JAXB_HOME%\lib\jaxb-xjc.jar -d . -extension -p com.calypso.tk.core.xml -use-runtime com.calypso.tk.util.xml.impl.runtime com/calypso/tk/core/xml/attributes.xsd

pause;
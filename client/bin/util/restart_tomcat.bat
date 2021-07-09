setlocal

set ERS_HOME=
if not defined ERS_HOME= set ERS_HOME=%~dp0STOPPER
set ERS_HOME=%ERS_HOME:\bin\util\STOPPER=%

touch %ERS_HOME%\services\webapps\risk-services\WEB-INF\web.xml

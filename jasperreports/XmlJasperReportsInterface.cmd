rem @echo off
set TMP_CLASSPATH=%CLASSPATH%

set CLASSPATH=%CLASSPATH%;.\bin
rem Add all jars....
for %%i in (".\lib\*.jar") do call ".\cpappend.cmd" %%i
for %%i in (".\lib\*.zip") do call ".\cpappend.cmd" %%i

set INTERFACE_CLASSPATH=%CLASSPATH%
set CLASSPATH=%TMP_CLASSPATH%

java -classpath "%INTERFACE_CLASSPATH%" XmlJasperReportsInterface %*


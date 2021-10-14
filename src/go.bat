IF "%PROCESSOR_ARCHITEW6432%"=="" GOTO native
%SystemRoot%\Sysnative\cmd.exe /c %0 %*
exit
:native

set JAVA_HOME=%~dp0vendor\jdk8u302-b08
SET PATH=%PATH%;%~dp0;%~dp0vendor\apache-ant-1.10.11\bin;
SET CLASSPATH=%CLASSPATH%;.;%~dp0vendor\SaxonHE10-6J\saxon-he-10.6.jar;

call ant
pause

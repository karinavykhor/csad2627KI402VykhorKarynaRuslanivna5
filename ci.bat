@echo off
call mvn -B -ntp verify
if errorlevel 1 exit /b %errorlevel%
if not exist dist mkdir dist
copy /Y target\hello.jar dist\hello.jar
if errorlevel 1 exit /b %errorlevel%

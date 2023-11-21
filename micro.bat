@echo off
REM Open VS and DOS CP

REM Open VS here
start devenv.exe

REM Pause
timeout /t 3 /nobreak >nul

REM Open DOS here
start cmd.exe

REM Fin

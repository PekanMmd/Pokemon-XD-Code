@ECHO off

:setup
cmd /q /c "CLI Compilers\link.bat"
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
goto :commands

:commands
if /I "%1"=="build" GOTO build
if /I "%1"=="build-god" GOTO build-god
if /I "%1"=="build-colo" GOTO build-colo
if /I "%1"=="build-pbr" GOTO build-pbr
if /I "%1"=="clean" GOTO clean

REM default command
goto :build
cmd /q /c "CLI Compilers\copy.bat"
:copy

goto :eof

:build
swift build
goto :eof

:build-god
swift build --product GoD-CLI
goto :eof

:build-colo
swift build --product Colosseum-CLI
goto :eof

:build-pbr
swift build --product PBR-CLI
goto :eof

:clean
rmdir /s /q .build
goto :eof

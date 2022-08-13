:: Swift setup
.\Assets\swift-5.5.1-RELEASE-windows10.exe

:: Cygwin setup
.\Assets\setup-x86_64.exe -d -n -q

:: Swift setup via winget, requires winget to be installed first so not as convenient for non devs
:: winget install Git.Git
:: winget install Python.Python.3

:: curl -sOL https://aka.ms/vs/16/release/vs_community.exe
:: start /w vs_community.exe --passive --wait --norestart --nocache ^
::  --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community" ^
::  --add Microsoft.VisualStudio.Component.Windows10SDK.19041 ^
::  --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64
:: del /q vs_community.exe

:: winget install Swift.Toolchain
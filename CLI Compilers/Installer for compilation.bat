:: Swift setup via winget, requires winget to be installed first so not as convenient for non devs
winget install Git.Git
winget install Python.Python.3 --version 3.10.2150.0

curl -sOL https://aka.ms/vs/16/release/vs_community.exe
start /w vs_community.exe --passive --wait --norestart --nocache ^
  --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community" ^
  --add Microsoft.VisualStudio.Component.Windows10SDK.19041 ^
  --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64
del /q vs_community.exe

pip install six

winget install Swift.Toolchain 

:: Undocumented extra step due to apparent error in toolchain's default folder structure
mkdir C:\Library\Developer\Toolchains\unknown-Asserts-development.xctoolchain\usr\lib\swift\windows
mkdir C:\Library\Developer\Toolchains\unknown-Asserts-development.xctoolchain\usr\lib\swift\windows\x86_64
copy C:\Library\Developer\Platforms\Windows.platform\Developer\SDKs\Windows.sdk\usr\lib\swift\windows\x86_64 C:\Library\Developer\Toolchains\unknown-Asserts-development.xctoolchain\usr\lib\swift\windows\x86_64
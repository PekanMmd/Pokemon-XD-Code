IF exist C:\Library\Developer\Platforms\Windows.platform\Developer\SDKs\Windows.sdk\usr\lib\swift ( rmdir /s C:\Library\Developer\Platforms\Windows.platform\Developer\SDKs\Windows.sdk\usr\lib\swift )
IF exist C:\Library\Developer\Platforms\Windows.platform\Developer\Library\XCTest-development\usr\lib\swift ( rmdir /s C:\Library\Developer\Platforms\Windows.platform\Developer\Library\XCTest-development\usr\lib\swift )

:: Swift setup
.\Assets\swift\swift-5.8.1-RELEASE-windows10.exe

:: Cygwin setup
.\Assets\cygwin\setup-x86_64.exe -q -n -N
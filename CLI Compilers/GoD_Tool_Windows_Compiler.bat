set SWIFTFLAGS=-sdk %SDKROOT% -resource-dir %SDKROOT%\usr\lib\swift -I %SDKROOT%\usr\lib\swift -L %SDKROOT%\usr\lib\swift\windows
swiftc %SWIFTFLAGS% -emit-executable -o out\GoD-Tool.exe GoD-CLI\main.swift extensions\WindowsExtensions.swift enums\XGFiles.swift "objects\file formats\XGISO.swift"
swiftc %SWIFTFLAGS% -emit-executable -o out\Colosseum-Tool.exe Colosseum-CLI\main.swift extensions\WindowsExtensions.swift
PAUSE

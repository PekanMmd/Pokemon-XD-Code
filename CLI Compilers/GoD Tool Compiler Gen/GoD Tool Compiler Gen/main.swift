//
//  main.swift
//  GoD Tool Compiler Gen
//
//  Created by Stars Momodu on 17/10/2020.
//

/// This is a helper tool for generating scripts that can be used to compile
/// the command line interface of Gale of Darkness Tool and Colosseum Tool
/// manually using the swift compiler, swiftc. This is mainly useful for
/// compiling the windows version. The .bat file that is output for windows
/// can be saved in the "CLI Compilers" folder of the GoD tool source code
/// and when run on a windows machine it will output the CLI tool.
/// Any files included in the CLI targets in xcode will be added to that
/// app's compile script.

import Foundation
import XcodeProj

/// Path to the GoD Tool .xcodeproj file at the top level of the source code
let path = "/Users/starsmomodu/Documents/Projects/Side Projects/GoD Tool/GoD Tool.xcodeproj"
/// Path in the GoD Tool source code where the compile scripts are kept
let outputPath = "/Users/starsmomodu/Documents/Projects/Side Projects/GoD Tool/CLI Compilers"

let project = try! XcodeProj(path: .init(path))
let pbxproj = project.pbxproj

let GoDCLITargetName = "GoD-CLI"
let ColoCLITargetName = "Colosseum-CLI"

let GoDTarget = pbxproj.targets(named: GoDCLITargetName)[0]
let ColoTarget = pbxproj.targets(named: ColoCLITargetName)[0]

let GoDSources = GoDTarget.buildPhases.first { (phase) -> Bool in
	phase.name() == "Sources"
}!.files!.map { (file) -> String? in
	if let fileData = file.file, let path = try? fileData.fullPath(sourceRoot: .init("")) {
		return path.string
	}
	return nil
}.compactMap { return $0 }

let ColoSources = ColoTarget.buildPhases.first { (phase) -> Bool in
	phase.name() == "Sources"
}!.files!.map { (file) -> String? in
	if let fileData = file.file, let path = try? fileData.fullPath(sourceRoot: .init("")) {
		return path.string
	}
	return nil
}.compactMap { return $0 }

var osxCompiler = "#!/bin/bash\ncd -- \"$(dirname \"$0\")\" #changes the terminal's directory to the directory where the script was launched\nswiftc -emit-executable -o ../out/GoD\\ Tool\\ CLI.app/GoD\\ Tool\\ CLI ../extensions/OSXExtensions.swift"
var windowsCompiler = "set SWIFTFLAGS=-sdk %SDKROOT% -resource-dir %SDKROOT%\\usr\\lib\\swift -I %SDKROOT%\\usr\\lib\\swift -L %SDKROOT%\\usr\\lib\\swift\\windows\nswiftc %SWIFTFLAGS% -emit-executable -o ..\\out\\GoD-Tool.exe  ..\\extensions\\WindowsExtensions.swift"

for file in GoDSources {
	osxCompiler += " ../" + file.replacingOccurrences(of: " ", with: "\\ ")
	windowsCompiler += " \"..\\" + file.replacingOccurrences(of: "/", with: "\\") + "\""
}

osxCompiler += "\nswiftc -emit-executable -o ../out/Colosseum\\ Tool\\ CLI.app/Colosseum\\ Tool\\ CLI ../extensions/OSXExtensions.swift"
windowsCompiler += "\nswiftc %SWIFTFLAGS% -emit-executable -o ..\\out\\Colosseum-Tool.exe ..\\extensions\\WindowsExtensions.swift"

for file in ColoSources {
	osxCompiler += " ../" + file.replacingOccurrences(of: " ", with: "\\ ")
	windowsCompiler += " \"..\\" + file.replacingOccurrences(of: "/", with: "\\") + "\""
}

let osxCompilerPath = outputPath + "/" + "GoD_Tool_OSX_Compiler.sh"
let windowsCompilerPath = outputPath + "/" + "GoD_Tool_Windows_Compiler.bat"

let osxData = osxCompiler.data(using: .utf8)!
let windowsData = windowsCompiler.data(using: .utf8)!

do {
	try osxData.write(to: URL(fileURLWithPath: osxCompilerPath), options: [.atomic])
	print("Successfully wrote OSX compiler script")
} catch {
	print("Failed to write OSX compiler script")
}

do {
	try windowsData.write(to: URL(fileURLWithPath: windowsCompilerPath), options: [.atomic])
	print("Successfully wrote Windows compiler script")
} catch {
	print("Failed to write Windows compiler script")
}

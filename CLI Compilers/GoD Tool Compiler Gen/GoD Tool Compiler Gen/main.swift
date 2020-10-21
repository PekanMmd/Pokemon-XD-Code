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

// MARK: - Load xcodeproj
/// Path to the GoD Tool .xcodeproj file at the top level of the source code
let path = "/Users/starsmomodu/Documents/Projects/Side Projects/GoD Tool/GoD Tool.xcodeproj"
/// Path in the GoD Tool source code where the compile scripts are kept
let outputPath = "/Users/starsmomodu/Documents/Projects/Side Projects/GoD Tool/CLI Compilers"

let project = try! XcodeProj(path: .init(path))
let pbxproj = project.pbxproj

let GoDCLITargetName = "GoD-CLI"
let GoDGUITargetName = "GoD Tool"
let ColoCLITargetName = "Colosseum-CLI"
let ColoGUITargetName = "Colosseum Tool"

let GoDTarget = pbxproj.targets(named: GoDCLITargetName)[0]
let GoDAssetTarget = pbxproj.targets(named: GoDGUITargetName)[0]
let ColoTarget = pbxproj.targets(named: ColoCLITargetName)[0]
let ColoAssetTarget = pbxproj.targets(named: ColoGUITargetName)[0]

let ignoredFiles = ["OSXExtensions.swift", "WindowsExtensions.swift"]
let resourceFileTypes = [".png", ".json", ".sublime"]

// MARK: - Read Source files

// Read XD Source files
let GoDSources = GoDTarget.buildPhases.first { (phase) -> Bool in
	phase.name() == "Sources"
}!.files!.map { (file) -> String? in
	if let fileData = file.file, let path = try? fileData.fullPath(sourceRoot: .init("")) {
		guard !ignoredFiles.contains(where: { (filename) -> Bool in
			return path.string.contains("/" + filename)
		}) else {
			return nil
		}
		return path.string
	}
	return nil
}.compactMap { return $0 }

// Read Colosseum Source files
let ColoSources = ColoTarget.buildPhases.first { (phase) -> Bool in
	phase.name() == "Sources"
}!.files!.map { (file) -> String? in
	if let fileData = file.file, let path = try? fileData.fullPath(sourceRoot: .init("")) {
		guard !ignoredFiles.contains(where: { (filename) -> Bool in
			return path.string.contains("/" + filename)
		}) else {
			return nil
		}
		return path.string
	}
	return nil
}.compactMap { return $0 }

// MARK: - Read Assets

// Read XD Assets
let GoDAssets = GoDAssetTarget.buildPhases.first { (phase) -> Bool in
	phase.name() == "Resources"
}!.files!.map { (file) -> (filename: String, path: String)? in
	if let fileData = file.file, let path = try? fileData.fullPath(sourceRoot: .init("")) {
		guard resourceFileTypes.contains(where: { (filetype) -> Bool in
			return path.string.contains(filetype)
		}) else {
			return nil
		}
		return (fileData.path ?? "", path.string)
	}
	return nil
}.compactMap { return $0 }

// Read Colosseum Assets
let ColoAssets = ColoAssetTarget.buildPhases.first { (phase) -> Bool in
	phase.name() == "Resources"
}!.files!.map { (file) -> (filename: String, path: String)? in
	if let fileData = file.file, let path = try? fileData.fullPath(sourceRoot: .init("")) {
		guard resourceFileTypes.contains(where: { (filetype) -> Bool in
			return path.string.contains(filetype)
		}) else {
			return nil
		}
		return (fileData.path ?? "", path.string)
	}
	return nil
}.compactMap { return $0 }

let GoDAssetsSubFolder = "./out/Assets"
let ColoAssetsSubFolder = "./out/Assets"
let GoDAssetsFolder = GoDAssetsSubFolder + "/XD"
let ColoAssetsFolder = ColoAssetsSubFolder + "/Colosseum"
let GoDWiimmsAssetsFolder = GoDAssetsFolder + "/wiimm"
let ColoWiimmsAssetsFolder = ColoAssetsFolder + "/wiimm"

// MARK: - Script set up

var osxCompiler = "#!/bin/bash\ncd -- \"$(dirname \"$0\")\" #changes the terminal's directory to the directory where the script was launched\n"
+ "echo \"Copying GoD Tool Assets. This may take a while...\"\n"
+ "mkdir " + GoDAssetsSubFolder + "\n"
+ "mkdir " + GoDAssetsFolder + "\n"
+ "mkdir " + GoDWiimmsAssetsFolder + "\n"

var windowsCompiler = "set SWIFTFLAGS=-sdk %SDKROOT% -resource-dir %SDKROOT%\\usr\\lib\\swift -I %SDKROOT%\\usr\\lib\\swift -L %SDKROOT%\\usr\\lib\\swift\\windows\n"
+ "echo \"Copying GoD Tool Assets. This may take a while...\"\n"
+ "mkdir " + GoDAssetsSubFolder.replacingOccurrences(of: "/", with: "\\") + "\n"
+ "mkdir " + GoDAssetsFolder.replacingOccurrences(of: "/", with: "\\") + "\n"
+ "mkdir " + GoDWiimmsAssetsFolder.replacingOccurrences(of: "/", with: "\\") + "\n"

// MARK: - Add copy XD assets to scripts

for asset in GoDAssets {
	osxCompiler += "cp ../\(asset.path.replacingOccurrences(of: " ", with: "\\ ")) \(GoDAssetsFolder)/\(asset.filename.replacingOccurrences(of: " ", with: "\\ "))\n"
	windowsCompiler += "copy \"..\\\(asset.path.replacingOccurrences(of: "/", with: "\\"))\" \"\((GoDAssetsFolder + "/" + asset.filename).replacingOccurrences(of: "/", with: "\\"))\"\n"
}
osxCompiler += "cp ../tools/OSX/wiimm/* \(GoDWiimmsAssetsFolder)\n"
windowsCompiler += "copy ..\\tools\\Windows\\wiimm\\* \((GoDWiimmsAssetsFolder).replacingOccurrences(of: "/", with: "\\"))\"\n"


// MARK: - Add XD swiftc compiler to scripts
osxCompiler += "echo \"Compiling GoD Tool. This may take a while...\"\n"
+ "swiftc -emit-executable -DENV_OSX -o ./out/GoD\\ Tool\\ CLI ../extensions/OSXExtensions.swift"

windowsCompiler += "echo \"Compiling GoD Tool. This may take a while...\"\n"
+ "swiftc %SWIFTFLAGS% -emit-executable -DENV_WINDOWS -o .\\out\\GoD-Tool.exe  ..\\extensions\\WindowsExtensions.swift"

for file in GoDSources {
	osxCompiler += " ../" + file.replacingOccurrences(of: " ", with: "\\ ")
	windowsCompiler += " \"..\\" + file.replacingOccurrences(of: "/", with: "\\") + "\""
}

// MARK: - Add copy Colosseum assets to scripts

osxCompiler += "\necho \"Copying Colosseum Tool Assets. This may take a while...\"\n"
+ "mkdir " + ColoAssetsSubFolder + "\n"
+ "mkdir " + ColoAssetsFolder + "\n"

windowsCompiler += "\necho \"Copying GoD Tool Assets. This may take a while...\"\n"
+ "mkdir " + ColoAssetsSubFolder.replacingOccurrences(of: "/", with: "\\") + "\n"
+ "mkdir " + ColoAssetsFolder.replacingOccurrences(of: "/", with: "\\") + "\n"

for asset in ColoAssets {
	osxCompiler += "cp ../\(asset.path.replacingOccurrences(of: " ", with: "\\ ")) \(ColoAssetsFolder)/\(asset.filename.replacingOccurrences(of: " ", with: "\\ "))\n"
	windowsCompiler += "copy \"..\\\(asset.path.replacingOccurrences(of: "/", with: "\\"))\" \"\((ColoAssetsFolder + "/" + asset.filename).replacingOccurrences(of: "/", with: "\\"))\"\n"
}
osxCompiler += "cp ../tools/OSX/wiimm/* \(ColoWiimmsAssetsFolder)\n"
windowsCompiler += "copy ..\\tools\\Windows\\wiimm\\* \((ColoWiimmsAssetsFolder).replacingOccurrences(of: "/", with: "\\"))\"\n"

// MARK: - Add Colosseum swiftc compiler to scripts
osxCompiler += "echo \"Compiling Colosseum Tool. This may take a while...\"\nswiftc -emit-executable -DENV_OSX -o ./out/Colosseum\\ Tool\\ CLI ../extensions/OSXExtensions.swift"
windowsCompiler += "\necho \"Compiling Colosseum Tool. This may take a while...\"\nswiftc %SWIFTFLAGS% -emit-executable -DENV_WINDOWS -o .\\out\\Colosseum-Tool.exe ..\\extensions\\WindowsExtensions.swift"

for file in ColoSources {
	osxCompiler += " ../" + file.replacingOccurrences(of: " ", with: "\\ ")
	windowsCompiler += " \"..\\" + file.replacingOccurrences(of: "/", with: "\\") + "\""
}
windowsCompiler += "\nPAUSE"

// MARK: - Modify OSX script for Linux

var linuxCompiler = osxCompiler.replacingOccurrences(of: "-DENV_OSX", with: "-DENV_LINUX")
linuxCompiler = linuxCompiler.replacingOccurrences(of: "../extensions/OSXExtensions.swift", with: "../extensions/LinuxExtensions.swift")
linuxCompiler = linuxCompiler.replacingOccurrences(of: "/tools/OSX/wiimm", with: "/tools/Linux/wiimm")

// MARK: - Write scripts to disk

let osxCompilerPath = outputPath + "/" + "GoD_Tool_OSX_Compiler.sh"
let linuxCompilerPath = outputPath + "/" + "GoD_Tool_Linux_Compiler.sh"
let windowsCompilerPath = outputPath + "/" + "GoD_Tool_Windows_Compiler.bat"

let osxData = osxCompiler.data(using: .utf8)!
let linuxData = linuxCompiler.data(using: .utf8)!
let windowsData = windowsCompiler.data(using: .utf8)!

do {
	try osxData.write(to: URL(fileURLWithPath: osxCompilerPath), options: [.atomic])
	print("Successfully wrote OSX compiler script")
} catch {
	print("Failed to write OSX compiler script")
}

do {
	try linuxData.write(to: URL(fileURLWithPath: linuxCompilerPath), options: [.atomic])
	print("Successfully wrote LINUX compiler script")
} catch {
	print("Failed to write LINUX compiler script")
}

do {
	try windowsData.write(to: URL(fileURLWithPath: windowsCompilerPath), options: [.atomic])
	print("Successfully wrote Windows compiler script")
} catch {
	print("Failed to write Windows compiler script")
}

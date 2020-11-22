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
let PBRCLITargetName = "PBR-CLI"
let PBRGUITargetName = "PBR Tool"

let GoDTarget = pbxproj.targets(named: GoDCLITargetName)[0]
let GoDAssetTarget = pbxproj.targets(named: GoDGUITargetName)[0]
let ColoTarget = pbxproj.targets(named: ColoCLITargetName)[0]
let ColoAssetTarget = pbxproj.targets(named: ColoGUITargetName)[0]
let PBRTarget = pbxproj.targets(named: PBRCLITargetName)[0]
let PBRAssetTarget = pbxproj.targets(named: PBRGUITargetName)[0]

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

// Read PBR Source files
let PBRSources = PBRTarget.buildPhases.first { (phase) -> Bool in
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

// Read PBR Assets
let PBRAssets = PBRAssetTarget.buildPhases.first { (phase) -> Bool in
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
let PBRAssetsSubFolder = "./out/Assets"
let GoDAssetsFolder = GoDAssetsSubFolder + "/XD"
let ColoAssetsFolder = ColoAssetsSubFolder + "/Colosseum"
let PBRAssetsFolder = PBRAssetsSubFolder + "/PBR"
let GoDWiimmsAssetsFolder = GoDAssetsFolder + "/wiimm"
let ColoWiimmsAssetsFolder = ColoAssetsFolder + "/wiimm"
let PBRWiimmsAssetsFolder = PBRAssetsFolder + "/wiimm"

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


// MARK: - Copy XD assets to scripts

for asset in GoDAssets {
	osxCompiler += "cp ../\(asset.path.replacingOccurrences(of: " ", with: "\\ ")) \(GoDAssetsFolder)/\(asset.filename.replacingOccurrences(of: " ", with: "\\ "))\n"
	windowsCompiler += "copy \"..\\\(asset.path.replacingOccurrences(of: "/", with: "\\"))\" \"\((GoDAssetsFolder + "/" + asset.filename).replacingOccurrences(of: "/", with: "\\"))\"\n"
}
osxCompiler += "cp ../tools/OSX/wiimm/* \(GoDWiimmsAssetsFolder)\n"
osxCompiler += "cp ../tools/OSX/other/* \(GoDAssetsFolder)\n"
windowsCompiler += "copy ..\\tools\\Windows\\wiimm\\* \((GoDWiimmsAssetsFolder).replacingOccurrences(of: "/", with: "\\"))\"\n"
windowsCompiler += "copy ..\\tools\\Windows\\other\\* \((GoDAssetsFolder).replacingOccurrences(of: "/", with: "\\"))\"\n"


// MARK: - Add XD swiftc compiler to scripts
osxCompiler += "echo \"Compiling GoD Tool. This may take a while...\"\n"
+ "swiftc -emit-executable -DENV_OSX -o ./out/GoD\\ Tool\\ CLI ../extensions/OSXExtensions.swift"

windowsCompiler += "echo \"Compiling GoD Tool. This may take a while...\"\n"
+ "swiftc %SWIFTFLAGS% -emit-executable -DENV_WINDOWS -o .\\out\\GoD-Tool.exe  ..\\extensions\\WindowsExtensions.swift"

for file in GoDSources {
	osxCompiler += " ../" + file.replacingOccurrences(of: " ", with: "\\ ")
	windowsCompiler += " \"..\\" + file.replacingOccurrences(of: "/", with: "\\") + "\""
}

// MARK: - Copy Colosseum assets to scripts

var osxColoCompiler = "#!/bin/bash\ncd -- \"$(dirname \"$0\")\" #changes the terminal's directory to the directory where the script was launched\necho \"Copying Colosseum Tool Assets. This may take a while...\"\n"
+ "mkdir " + ColoAssetsSubFolder + "\n"
+ "mkdir " + ColoAssetsFolder + "\n"
+ "mkdir " + ColoWiimmsAssetsFolder + "\n"

var windowsColoCompiler = "set SWIFTFLAGS=-sdk %SDKROOT% -resource-dir %SDKROOT%\\usr\\lib\\swift -I %SDKROOT%\\usr\\lib\\swift -L %SDKROOT%\\usr\\lib\\swift\\windows\necho \"Copying Colosseum Tool Assets. This may take a while...\"\n"
+ "mkdir " + ColoAssetsSubFolder.replacingOccurrences(of: "/", with: "\\") + "\n"
+ "mkdir " + ColoAssetsFolder.replacingOccurrences(of: "/", with: "\\") + "\n"
+ "mkdir " + ColoWiimmsAssetsFolder.replacingOccurrences(of: "/", with: "\\") + "\n"

for asset in ColoAssets {
	osxColoCompiler += "cp ../\(asset.path.replacingOccurrences(of: " ", with: "\\ ")) \(ColoAssetsFolder)/\(asset.filename.replacingOccurrences(of: " ", with: "\\ "))\n"
	windowsColoCompiler += "copy \"..\\\(asset.path.replacingOccurrences(of: "/", with: "\\"))\" \"\((ColoAssetsFolder + "/" + asset.filename).replacingOccurrences(of: "/", with: "\\"))\"\n"
}
osxColoCompiler += "cp ../tools/OSX/wiimm/* \(ColoWiimmsAssetsFolder)\n"
osxColoCompiler += "cp ../tools/OSX/other/* \(ColoAssetsFolder)\n"
windowsColoCompiler += "copy ..\\tools\\Windows\\wiimm\\* \((ColoWiimmsAssetsFolder).replacingOccurrences(of: "/", with: "\\"))\"\n"
windowsColoCompiler += "copy ..\\tools\\Windows\\other\\* \((ColoAssetsFolder).replacingOccurrences(of: "/", with: "\\"))\"\n"

// MARK: - Add Colosseum swiftc compiler to scripts
osxColoCompiler += "echo \"Compiling Colosseum Tool. This may take a while...\"\nswiftc -emit-executable -DENV_OSX -o ./out/Colosseum\\ Tool\\ CLI ../extensions/OSXExtensions.swift"
windowsColoCompiler += "\necho \"Compiling Colosseum Tool. This may take a while...\"\nswiftc %SWIFTFLAGS% -emit-executable -DENV_WINDOWS -o .\\out\\Colosseum-Tool.exe ..\\extensions\\WindowsExtensions.swift"

for file in ColoSources {
	osxColoCompiler += " ../" + file.replacingOccurrences(of: " ", with: "\\ ")
	windowsColoCompiler += " \"..\\" + file.replacingOccurrences(of: "/", with: "\\") + "\""
}
windowsCompiler += "\nPAUSE"
windowsColoCompiler += "\nPAUSE"

// MARK: - Copy PBR assets to scripts

var osxPBRCompiler = "#!/bin/bash\ncd -- \"$(dirname \"$0\")\" #changes the terminal's directory to the directory where the script was launched\necho \"Copying PBR Tool Assets. This may take a while...\"\n"
+ "mkdir " + PBRAssetsSubFolder + "\n"
+ "mkdir " + PBRAssetsFolder + "\n"
+ "mkdir " + PBRWiimmsAssetsFolder + "\n"

var windowsPBRCompiler = "set SWIFTFLAGS=-sdk %SDKROOT% -resource-dir %SDKROOT%\\usr\\lib\\swift -I %SDKROOT%\\usr\\lib\\swift -L %SDKROOT%\\usr\\lib\\swift\\windows\necho \"Copying PBR Tool Assets. This may take a while...\"\n"
+ "mkdir " + PBRAssetsSubFolder.replacingOccurrences(of: "/", with: "\\") + "\n"
+ "mkdir " + PBRAssetsFolder.replacingOccurrences(of: "/", with: "\\") + "\n"
+ "mkdir " + PBRWiimmsAssetsFolder.replacingOccurrences(of: "/", with: "\\") + "\n"

for asset in PBRAssets {
	osxPBRCompiler += "cp ../\(asset.path.replacingOccurrences(of: " ", with: "\\ ")) \(PBRAssetsFolder)/\(asset.filename.replacingOccurrences(of: " ", with: "\\ "))\n"
	windowsPBRCompiler += "copy \"..\\\(asset.path.replacingOccurrences(of: "/", with: "\\"))\" \"\((PBRAssetsFolder + "/" + asset.filename).replacingOccurrences(of: "/", with: "\\"))\"\n"
}
osxPBRCompiler += "cp ../tools/OSX/wiimm/* \(PBRWiimmsAssetsFolder)\n"
osxPBRCompiler += "cp ../tools/OSX/other/* \(PBRAssetsFolder)\n"
windowsPBRCompiler += "copy ..\\tools\\Windows\\wiimm\\* \((PBRWiimmsAssetsFolder).replacingOccurrences(of: "/", with: "\\"))\"\n"
windowsPBRCompiler += "copy ..\\tools\\Windows\\other\\* \((PBRAssetsFolder).replacingOccurrences(of: "/", with: "\\"))\"\n"

// MARK: - Add PBR swiftc compiler to scripts
osxPBRCompiler += "echo \"Compiling PBR Tool. This may take a while...\"\nswiftc -emit-executable -DENV_OSX -o ./out/PBR\\ Tool\\ CLI ../extensions/OSXExtensions.swift"
windowsPBRCompiler += "\necho \"Compiling PBR Tool. This may take a while...\"\nswiftc %SWIFTFLAGS% -emit-executable -DENV_WINDOWS -o .\\out\\PBR-Tool.exe ..\\extensions\\WindowsExtensions.swift"

for file in PBRSources {
	osxPBRCompiler += " ../" + file.replacingOccurrences(of: " ", with: "\\ ")
	windowsPBRCompiler += " \"..\\" + file.replacingOccurrences(of: "/", with: "\\") + "\""
}
windowsCompiler += "\nPAUSE"
windowsColoCompiler += "\nPAUSE"
windowsPBRCompiler += "\nPAUSE"

// MARK: - Modify OSX script for Linux

var linuxCompiler = osxCompiler.replacingOccurrences(of: "-DENV_OSX", with: "-DENV_LINUX")
linuxCompiler = linuxCompiler.replacingOccurrences(of: "../extensions/OSXExtensions.swift", with: "../extensions/LinuxExtensions.swift")
linuxCompiler = linuxCompiler.replacingOccurrences(of: "/tools/OSX/wiimm", with: "/tools/Linux/wiimm")
linuxCompiler = linuxCompiler.replacingOccurrences(of: "/tools/OSX/other", with: "/tools/Linux/other")
var linuxColoCompiler = osxColoCompiler.replacingOccurrences(of: "-DENV_OSX", with: "-DENV_LINUX")
linuxColoCompiler = linuxColoCompiler.replacingOccurrences(of: "../extensions/OSXExtensions.swift", with: "../extensions/LinuxExtensions.swift")
linuxColoCompiler = linuxColoCompiler.replacingOccurrences(of: "/tools/OSX/wiimm", with: "/tools/Linux/wiimm")
linuxColoCompiler = linuxColoCompiler.replacingOccurrences(of: "/tools/OSX/other", with: "/tools/Linux/other")
var linuxPBRCompiler = osxPBRCompiler.replacingOccurrences(of: "-DENV_OSX", with: "-DENV_LINUX")
linuxPBRCompiler = linuxPBRCompiler.replacingOccurrences(of: "../extensions/OSXExtensions.swift", with: "../extensions/LinuxExtensions.swift")
linuxPBRCompiler = linuxPBRCompiler.replacingOccurrences(of: "/tools/OSX/wiimm", with: "/tools/Linux/wiimm")
linuxPBRCompiler = linuxPBRCompiler.replacingOccurrences(of: "/tools/OSX/other", with: "/tools/Linux/other")

// MARK: - Write scripts to disk

let osxCompilerPath = outputPath + "/" + "GoD_Tool_OSX_Compiler.sh"
let linuxCompilerPath = outputPath + "/" + "GoD_Tool_Linux_Compiler.sh"
let windowsCompilerPath = outputPath + "/" + "GoD_Tool_Windows_Compiler.bat"
let osxColoCompilerPath = outputPath + "/" + "Colosseum_Tool_OSX_Compiler.sh"
let linuxColoCompilerPath = outputPath + "/" + "Colosseum_Tool_Linux_Compiler.sh"
let windowsColoCompilerPath = outputPath + "/" + "Colosseum_Tool_Windows_Compiler.bat"
let osxPBRCompilerPath = outputPath + "/" + "PBR_Tool_OSX_Compiler.sh"
let linuxPBRCompilerPath = outputPath + "/" + "PBR_Tool_Linux_Compiler.sh"
let windowsPBRCompilerPath = outputPath + "/" + "PBR_Tool_Windows_Compiler.bat"

let osxData = osxCompiler.data(using: .utf8)!
let linuxData = linuxCompiler.data(using: .utf8)!
let windowsData = windowsCompiler.data(using: .utf8)!
let osxColoData = osxColoCompiler.data(using: .utf8)!
let linuxColoData = linuxColoCompiler.data(using: .utf8)!
let windowsColoData = windowsColoCompiler.data(using: .utf8)!
let osxPBRData = osxPBRCompiler.data(using: .utf8)!
let linuxPBRData = linuxPBRCompiler.data(using: .utf8)!
let windowsPBRData = windowsPBRCompiler.data(using: .utf8)!

do {
	try osxData.write(to: URL(fileURLWithPath: osxCompilerPath), options: [.atomic])
	print("Successfully wrote XD OSX compiler script")
} catch {
	print("Failed to write XD OSX compiler script")
}

do {
	try osxColoData.write(to: URL(fileURLWithPath: osxColoCompilerPath), options: [.atomic])
	print("Successfully wrote Colosseum OSX compiler script")
} catch {
	print("Failed to write Colosseum OSX compiler script")
}

do {
	try osxPBRData.write(to: URL(fileURLWithPath: osxPBRCompilerPath), options: [.atomic])
	print("Successfully wrote PBR OSX compiler script")
} catch {
	print("Failed to write PBR OSX compiler script")
}

do {
	try linuxData.write(to: URL(fileURLWithPath: linuxCompilerPath), options: [.atomic])
	print("Successfully wrote XD LINUX compiler script")
} catch {
	print("Failed to write XD LINUX compiler script")
}

do {
	try linuxColoData.write(to: URL(fileURLWithPath: linuxColoCompilerPath), options: [.atomic])
	print("Successfully wrote Colosseum LINUX compiler script")
} catch {
	print("Failed to write Colosseum LINUX compiler script")
}

do {
	try linuxPBRData.write(to: URL(fileURLWithPath: linuxPBRCompilerPath), options: [.atomic])
	print("Successfully wrote PBR LINUX compiler script")
} catch {
	print("Failed to write PBR LINUX compiler script")
}

do {
	try windowsData.write(to: URL(fileURLWithPath: windowsCompilerPath), options: [.atomic])
	print("Successfully wrote XD Windows compiler script")
} catch {
	print("Failed to write XD Windows compiler script")
}

do {
	try windowsColoData.write(to: URL(fileURLWithPath: windowsColoCompilerPath), options: [.atomic])
	print("Successfully wrote Colosseum Windows compiler script")
} catch {
	print("Failed to write Colosseum Windows compiler script")
}

do {
	try windowsPBRData.write(to: URL(fileURLWithPath: windowsPBRCompilerPath), options: [.atomic])
	print("Successfully wrote PBR Windows compiler script")
} catch {
	print("Failed to write PBR Windows compiler script")
}

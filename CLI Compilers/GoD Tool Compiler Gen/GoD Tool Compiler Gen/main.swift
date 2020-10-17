//
//  main.swift
//  GoD Tool Compiler Gen
//
//  Created by Stars Momodu on 17/10/2020.
//

import Foundation
import XcodeProj

let path = "/Users/starsmomodu/Documents/Projects/Side Projects/GoD Tool/GoD Tool.xcodeproj"
let outputPath = "/Users/starsmomodu/Documents/Projects/Side Projects/GoD Tool/CLI Compilers"

let project = try! XcodeProj(path: .init(path))
let pbxproj = project.pbxproj

var filePathsByUUID = [String: String]()

pbxproj.fileReferences.forEach { (file) in

	if let path = try? file.fullPath(sourceRoot: .init("")) {
		filePathsByUUID[file.uuid] = path.string
	}
}

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

let osxCompiler = "#!/bin/bash\ncd -- \"$(dirname \"$0\")\" #changes the terminal's directory to the directory where the script was launched\nswiftc -emit-executable -o out/GoD\ Tool\ CLI.app/GoD\ Tool\ CLI"

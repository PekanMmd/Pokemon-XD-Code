//
//  CMScriptCompiler.swift
//  GoD Tool
//
//  Created by The Steez on 01/11/2018.
//

import Foundation

// just a placeholder
class XDSScriptCompiler: NSObject {
	typealias XDSCode = [UInt32]
	
	// special variables
	static var scriptID = 0 // currently unknown what this value represents
	static var baseStringID = 0
	static var xdsversion : Float = 0.0
	static var writeDisassembly = false
	static var decompileXDS = false
	static var updateStringIDs = false
	static var increaseMSGSize = false
	static var createBackup = true
	
	static var scriptFile : XGFiles?
	static var error = "No compiler for colosseum scripts"
	
	class func setFlags(disassemble: Bool, decompile: Bool, updateStrings: Bool, increaseMSG: Bool) { }
	
	class func clearCompilerFlags() { }
	
	// MARK: - specify file or text to compile
	class func compile(textFile file: XGFiles) -> Bool {
		return false
	}
	
	class func compile(textFile file: XGFiles, toFile target: XGFiles) -> Bool {
		return false
	}
	
	class func compile(text: String, toFile file: XGFiles) -> Bool {
		return false
	}
}

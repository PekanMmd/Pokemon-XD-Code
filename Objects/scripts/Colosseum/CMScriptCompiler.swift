//
//  CMScriptCompiler.swift
//  GoD Tool
//
//  Created by The Steez on 01/11/2018.
//

import Foundation

// just a placeholder
class XDSScriptCompiler: NSObject {
	typealias CMSCode = [UInt32]
	
	// special variables
	static var scriptTypeID = 0
	static var baseStringID = 0
	static var cmsversion : Float = 0.9
	static var writeDisassembly = false
	static var decompileXDS = false
	static var updateStringIDs = false
	static var increaseMSGSize = false
	static var createBackup = true
	
	static var scriptFile : XGFiles?
	static var error = ""
	
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

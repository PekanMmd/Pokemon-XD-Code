//
//  XGScriptInstructions.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

class XGScriptInstruction : NSObject {
	
	var opcode			= XGScriptOps.nop
	var subOpcode		= 0
	var parameter		= 0 {
		didSet {
//			self._parameter = -((~val2 + 1) & 0xffff) if ((val2 & 0x8000) == 0x8000) else val2

			if (self.parameter & 0x8000) == 0x8000 {
				self.parameter = -((~0x8000 + 1) & 0xFFFF)
			}
		}
	}
	
	var position		= 0
	var nextPosition	= 0
	
	var label			= ""
	
	var file			= XGFiles.script("")
	
	var name : String {
		return opcode.name
	}
	
	var subSubOpcode1 : Int {
		return self.subOpcode >> 4
	}
	
	var subSubOpcode2 : Int {
		return self.subOpcode & 0xF
	}
	
	var instructionID : Int {
		return (self.subOpcode << 16) | (self.parameter & 0xFFFF)
	}
	
	func checkVariable() {
		let level = self.subSubOpcode2
		if level == 0 {
			if self.parameter < 0 {
				print("warning negative gloabal variable id at position \(self.position)")
			}
		} else if level == 2 {
			if self.parameter != 0 {
				print("warning negative last result id at position \(self.position)")
			}
		} else if level == 3 {
			if (self.parameter < 0) || (self.parameter > 0x2FF) || ((0x120 < self.parameter) && (self.parameter < 0x200)) {
				print("warning invalid special variable id at position \(self.position)")
			}
		}
	}
	
	func variableName() -> String {
		let level = self.subSubOpcode2
		if level == 0 {
			return "$globals[\(self.parameter)]"
		} else if level == 1 {
			return "$stack[\(self.parameter)]"
		} else if level == 2 {
			return "$LastResult"
		} else {
			if (self.parameter < 0) || (self.parameter > 0x2FF) || ((0x120 < self.parameter) && (self.parameter < 0x200)) {
				return "$InvalidSpecials[\(self.parameter)]"
			} else if self.parameter < 0x80 {
				return "$" + (classNames[self.parameter] ?? "UnknownClass\(self.parameter)").lowercased()
			} else if ((0x120 < self.parameter) && (self.parameter < 0x200)) {
				return "$characters[\(self.parameter - 0x80)]"
			} else {
				return "$arrays[\(self.parameter - 0x200)]"
			}
		}
	}
	
	var rawBytes : Int {
		return (self.opcode.rawValue << 24) | (self.subOpcode << 16) | self.parameter
	}
	
	func check() {
		//TODO: - Implement
	}
	
	init(bytes: Int, position: Int, label: String, file: XGFiles) {
		super.init()
		
		
		let op				= (bytes >> 24) & 0xFF
		self.opcode			= XGScriptOps(rawValue: op) ?? .nop
		self.subOpcode		= (bytes >> 16) & 0xFF
		self.parameter		= bytes & 0xFFFF
		
		self.position		= position
		self.nextPosition	= position + 1
		self.label			= label
		
		self.file = file
		
		self.check()
	}
	
	func string() -> String {
		
		let opcode = self.opcode.rawValue
		
		let instructionName = opcode <= 17 ? self.name : "Illegal\(self.opcode)"
		
		var instructionString = ""
		
		if opcode > 17 {
			// Illegal opcodes
			return instructionName + " \(self.subOpcode) \(self.parameter)"
		} else if (self.opcode == .nop) || (self.opcode == .return) || (self.opcode == .exit) {
			
			if (self.parameter == 0) && (self.subOpcode == 0) {
				return ""
			} else {
				return "(\(self.subOpcode),\(self.parameter))"
			}
			
		} else if self.opcode == .operator {
			
			return XGScriptClassesInfo.operators[self.subOpcode].name
			
		} else if self.opcode == .loadImmediate {
			
			
			
		}
		
		//TODO:- Complete implementation
		return ""
	}

	
	
}
































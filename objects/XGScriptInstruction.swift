//
//  XGScriptInstruction.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2017.
//
//

import Cocoa

let kXDSLastResultVariable = "LastResult"

class XGScriptInstruction: NSObject {
	
	var isScriptFunctionLastResult = false // set during decompilation to prevent being attributed to the wrong function
	var isUnusedPostpendedCall = false // set during decompilation to prevent parsing stray function calls at end of script
	
	var opCode = XGScriptOps.nop
	var subOpCode = 0
	var parameter = 0
	
	var longParameter = 0 // used by 'call', 'jumptrue', 'jumpfalse', and 'jump'
	var subSubOpCodes = (0,0)
	
	var length = 1
	
	var raw1 : UInt32 = 0
	var raw2 : UInt32 = 0
	
	var constant : XDSConstant!
	
	var SCDVariable : String {
		let param = self.parameter
		switch self.subOpCode {
		case 0:
			return "#GVAR[\(self.parameter)]"
		case 1:
			return "#Stack[\(self.parameter)]"
		case 2:
			return "#LastResult"
		default:
			if param < 0x80 && param > 0 {
				return "#" + XGScriptClassesInfo.classes(param).name.lowercased() + "Object"
			} else if param == 0x80 {
				return "#characters[player]"
			} else if param <= 0x120 {
				return "#characters[\(param - 0x80)]"
			} else if param < 0x300 && param >= 0x200 {
				return "#arrays[\(param - 0x200)]"
			} else {
				return "#invalid"
			}
		}
	}
	
	var XDSVariable : String {
		let param = self.parameter
		switch self.subOpCode {
		case 0:
			return "gvar_\(param)"
		case 1:
			return param < 0 ? "var_\(-param)" : "arg_\(param - 1)"
		case 2:
			return kXDSLastResultVariable
		default:
			if param < 0x80 && param > 0 {
				return XGScriptClassesInfo.classes(param).name.lowercased() + "_object"
			} else if param == 0x80 {
				return "player_character_object"
			} else if param <= 0x120 {
				return "character_object\(param - 0x80)"
			} else if param < 0x300 && param >= 0x200 {
				return "array_\(param - 0x200)"
			} else {
				return "_invalid_var_"
			}
		}
	}
	
	init(bytes: UInt32, next: UInt32) {
		super.init()
		
		let op				= ((bytes >> 24) & 0xFF).int
		self.opCode			= XGScriptOps(rawValue: op) ?? .nop
		self.subOpCode		= ((bytes >> 16) & 0xFF).int
		self.parameter		= (bytes & 0xFFFF).int16
		
		self.longParameter  = (bytes & 0xFFFFFF).int
		self.subSubOpCodes  = ((self.subOpCode >> 4), self.subOpCode & 0xf)
		
		self.raw1 = bytes
		self.raw2 = 0
		
		if self.opCode == .loadImmediate {
			self.constant = XDSConstant(type: self.subOpCode, rawValue: next)
			
			var shortType = false
			switch constant.type {
			case .vector:
				fallthrough
			case .string:
				self.constant.value = UInt32(self.parameter)
				shortType = true
			default:
				break
			}
			
			if !shortType {
				self.length = 2
				self.parameter = next.int32
				self.raw2 = next
			}
			
		}
		
	}
	
	override var description: String {
		var param = self.parameter
		switch self.opCode {
		case .call:
			fallthrough
		case .jumpIfTrue:
			fallthrough
		case .jumpIfFalse:
			fallthrough
		case .jump:
			param = self.longParameter
		default:
			break
		}
		
		var sub = "\(self.subOpCode) "
		switch self.opCode {
		case .nop:
			fallthrough
		case .return_op:
			fallthrough
		case .loadVariable:
			fallthrough
		case .setVariable:
			fallthrough
		case .loadNonCopyableVariable:
			fallthrough
		case .setLine:
			fallthrough
		case .jump:
			fallthrough
		case .jumpIfFalse:
			fallthrough
		case .jumpIfTrue:
			fallthrough
		case .call:
			fallthrough
		case .loadImmediate:
			sub = ""
		case .callStandard:
			sub = XGScriptClassesInfo.classes(self.subOpCode).name + "."
		case .xd_operator:
			sub = XGScriptClassesInfo.operators.operatorWithID(self.subOpCode).name
		case .setVector:
			let dimensions = ["v.x ","v.y ", "v.z "]
			let index = self.subSubOpCodes.0
			sub = index < 3 ? dimensions[index] : "error"
		default:
			break
		}
		
		var paramString = param.string + " (" + param.hexString() + ")"
		switch self.opCode {
		case .jump:
			fallthrough
		case .jumpIfTrue:
			fallthrough
		case.jumpIfFalse:
			paramString = param.hexString()
		case .loadVariable:
			fallthrough
		case .setVariable:
			fallthrough
		case .setVector:
			fallthrough
		case .loadNonCopyableVariable:
			paramString = self.SCDVariable
		case .callStandard:
			paramString = XGScriptClassesInfo.classes(self.subOpCode)[param].name + "()"
		case .loadImmediate:
			paramString = self.constant.description + " (" + param.hexString() + ")"
		case .pop:
			fallthrough
		case .release:
			fallthrough
		case .return_op:
			fallthrough
		case .nop:
			fallthrough
		case .reserve:
			fallthrough
		case .xd_operator:
			paramString = ""
		default:
			break
		}
		
		return self.opCode.name + " " + sub + paramString
	}

}

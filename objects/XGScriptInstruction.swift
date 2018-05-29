//
//  XGScriptInstruction.swift
//  GoD Tool
//
//  Created by The Steez on 26/10/2017.
//
//

import Cocoa

class XGScriptInstruction: NSObject {
	
	var opCode = XGScriptOps.nop
	var subOpCode = 0
	var parameter = 0
	
	var longParameter = 0 // used by 'call', 'jumptrue', 'jumpfalse', and 'jump'
	var subSubOpCodes = (0,0)
	
	var length = 1
	
	var raw1 : UInt32 = 0
	var raw2 : UInt32 = 0
	
	var scriptVar : XGScriptVar!
	
	
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
			self.scriptVar = XGScriptVar(type: self.subOpCode, rawValue: next)
			
			var strType = false
			switch scriptVar.type {
			case .string:
				self.scriptVar.value = UInt32(self.parameter)
				strType = true
			default:
				break
			}
			
			if !strType {
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
		case .loadNonCopyableVariable:
			switch self.subOpCode {
			case 0:
				paramString = "#GVAR[\(self.parameter)]"
			case 1:
				paramString = "#Stack[\(self.parameter)]"
			case 2:
				paramString = "#LastResult"
			default:
				if param < 0x80 && param > 0 {
					paramString = "#" + XGScriptClassesInfo.classes(param).name.lowercased()
				} else if param == 0x80 {
					paramString = "#characters[player]"
				} else if param <= 0x120 {
					paramString = "#characters[\(param - 0x80)]"
				} else if param < 0x300 && param >= 0x200 {
					paramString = "#arrays[\(param - 0x200)]"
				} else {
					paramString = "#invalid"
				}
				
			}
		case .callStandard:
			paramString = XGScriptClassesInfo.classes(self.subOpCode)[param].name + "()"
		case .loadImmediate:
			paramString = self.scriptVar.description + " (" + param.hexString() + ")"
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

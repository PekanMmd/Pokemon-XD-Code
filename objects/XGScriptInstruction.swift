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
	
	@objc var isScriptFunctionLastResult = false // set during decompilation to prevent being attributed to the wrong function
	@objc var isUnusedPostpendedCall = false // set during decompilation to prevent parsing stray function calls at end of script
	
	var opCode = XGScriptOps.nop
	@objc var subOpCode = 0
	@objc var parameter = 0
	
	@objc var longParameter = 0 // used by 'call', 'jumptrue', 'jumpfalse', and 'jump'
	var subSubOpCodes = (0,0)
	
	@objc var level = 0
	
	@objc var length = 1
	
	@objc var raw1 : UInt32 = 0
	@objc var raw2 : UInt32 = 0
	
	@objc var constant : XDSConstant!
	
	@objc var SCDVariable : String {
		let param = self.parameter
		let (_, level) = self.subSubOpCodes
		switch level {
		case 0:
			return "#GVAR[\(self.parameter)]"
		case 1:
			return "#Stack[\(self.parameter)]"
		case 2:
			return "#LastResult"
		default:
			if param < 0x80 && param > 0 {
				return "#" + XGScriptClass.classes(param).name.lowercased() + "Object"
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
	
	var isVariable : Bool {
		return self.opCode == .loadVariable || self.opCode == .loadNonCopyableVariable || self.opCode == .setVariable
	}
	
	var isLocalVariable : Bool {
		return self.isVariable && self.level == 1
	}
	
	var isGlobalVariable : Bool {
		return self.isVariable && self.level == 0
	}
	
	var isArrayVariable : Bool {
		return self.isVariable && self.level == 3 && self.parameter >= 0x200
	}
	
	@objc var XDSVariable : String {
		// add an asterisk to last result, local variables and script function parameters if the type of the varible isn't copyable.
		// it is incredibly difficult to infer the underlying type for these variables.
		
		let param = self.parameter
		switch self.level {
		case 0:
			return "gvar_" + String(format: "%02d", param)
		case 1:
			var pointerAdd = ""
			switch self.opCode {
			case .loadNonCopyableVariable:
				pointerAdd = "*"
			default:
				pointerAdd = ""
			}
			return (param < 0 ? "var_\(-param)" : "arg_\(param - 1)") + pointerAdd
		case 2:
			var pointerAdd = ""
			switch self.opCode {
			case .loadNonCopyableVariable:
				pointerAdd = "*"
			default:
				pointerAdd = ""
			}
			return kXDSLastResultVariable + pointerAdd
		default:
			if param < 0x80 && param > 0 {
				return XGScriptClass.classes(param).name.capitalized
			} else if param == 0x80 {
				return "player_character"
			} else if param <= 0x120 {
				return "character_" + String(format: "%02d", param - 0x80)
			} else if param < 0x300 && param >= 0x200 {
				return "array_" + String(format: "%02d", param - 0x200)
			} else {
				return "_invalid_var_"
			}
		}
	}
	
	var vectorDimension : XDSVectorDimension {
		let (d, _) = self.subSubOpCodes
		return XDSVectorDimension(rawValue: d) ?? .invalid
	}
	
	@objc init(bytes: UInt32, next: UInt32) {
		super.init()
		
		let op				= ((bytes >> 24) & 0xFF).int
		self.opCode			= XGScriptOps(rawValue: op) ?? .nop
		self.subOpCode		= ((bytes >> 16) & 0xFF).int
		self.parameter		= (bytes & 0xFFFF).int16
		
		self.longParameter  = (bytes & 0xFFFFFF).int
		self.subSubOpCodes  = ((self.subOpCode >> 4), self.subOpCode & 0xf)
		self.level		    = self.subSubOpCodes.1
		
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
	
	convenience init(opCode: XGScriptOps, subOpCode: Int, parameter: Int) {
		let op = (opCode.rawValue << 24)
		let sub = (subOpCode << 16)
		let param = (parameter & 0xFFFF)
		self.init(bytes: UInt32( op + sub + param ), next: 0)
	}
	
	class func variableInstruction(op: XGScriptOps, level: Int, index: Int) -> XGScriptInstruction {
		return XGScriptInstruction(opCode: op, subOpCode: level, parameter: index)
	}
	
	class func functionCall(classID: Int, funcID: Int) -> XGScriptInstruction {
		return XGScriptInstruction(opCode: .callStandard, subOpCode: classID, parameter: funcID)
	}
	
	class func loadImmediate(c: XDSConstant) -> XGScriptInstruction {
		
		switch c.type {
		case .string:
			fallthrough
		case .vector:
			return XGScriptInstruction(opCode: .loadImmediate, subOpCode: c.type.index, parameter: c.value.int)
		default:
			let code : UInt32 = UInt32(XGScriptOps.loadImmediate.rawValue << 24) + (UInt32(c.type.index) << 16)
			return XGScriptInstruction(bytes: code, next: c.value)
		}
		
	}
	
	class func xdsoperator(op: Int) -> XGScriptInstruction {
		return XGScriptInstruction(opCode: .xd_operator, subOpCode: op, parameter: 0)
	}
	
	class func nopInstruction() -> XGScriptInstruction {
		return XGScriptInstruction(opCode: .nop, subOpCode: 0, parameter: 0)
	}
	
	class func call(location: Int) -> XGScriptInstruction {
		return XGScriptInstruction(opCode: .call, subOpCode: 0, parameter: location)
	}
	
	class func loadVarLastResult() -> XGScriptInstruction {
		return XGScriptInstruction.variableInstruction(op: .loadVariable, level: 2, index: 0)
	}
	
	class func jump(op: XGScriptOps, location: Int) -> XGScriptInstruction {
		return XGScriptInstruction(opCode: op, subOpCode: 0, parameter: location)
	}
	
	class func reserve(count: Int) -> XGScriptInstruction {
		return XGScriptInstruction(opCode: .reserve, subOpCode: count, parameter: 0)
	}
	
	class func release(count: Int) -> XGScriptInstruction {
		return XGScriptInstruction(opCode: .release, subOpCode: count, parameter: 0)
	}
	
	class func xdsreturn() -> XGScriptInstruction {
		return XGScriptInstruction(opCode: .return_op, subOpCode: 0, parameter: 0)
	}
	
	class  func pop(count: Int) -> XGScriptInstruction {
		return XGScriptInstruction(opCode: .pop, subOpCode: count, parameter: 0)
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
			sub = XGScriptClass.classes(self.subOpCode).name + "."
		case .xd_operator:
			sub = XGScriptClass.operators[self.subOpCode].name
		case .setVector:
			let dimensions = ["vx ","vy ", "vz "]
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
			paramString = XGScriptClass.classes(self.subOpCode)[param].name + "()"
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

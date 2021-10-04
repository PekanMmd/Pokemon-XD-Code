//
//  XDSConstant.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

enum XDSConstantTypes: Equatable {

	// same as classes in script class info
	case void
	case integer		
	case float
	case string		// 1 byte per character
	case vector
	case matrix
	case object
	case array
	#if GAME_XD
	case text      // 2 bytes per character
	#endif
	// possible type names from strings in start.dol
	/*
	case cmp_task
	case cmp_frame
	case cmp_model
	case cmp_light
	case cmp_texture
	case cmp_switch
	case cmp_frame_motion
	case cmp_pad
	case cmp_player
	case cmp_map
	case cmp_enemy
	case cmp_camera
	case cmp_chara
	case cmp_adpcm
	case cmp_text
	case cmp_fog
	case cmp_menu
	case cmp_blight
	case cmp_radio
	case cmp_item
	case cmp_effect
	case cmp_sound
	case cmp_last
    */
	#if GAME_XD
	case character		
	case index
	#endif
	case codePointer
	case unknown(Int)
	
	var string: String {
		switch self {
		case .void				: return "Void"
		case .integer			: return "Int"
		case .float				: return "Float"
		case .string			: return "String"
		case .vector			: return "Vector"
		case .matrix			: return "Matrix"
		case .object			: return "Object"
		case .array				: return "Array"
		#if GAME_XD
		case .text				: return "Text"
		case .character			: return "Character"
		case .index			: return "Pokemon"
		#endif
		case .codePointer		: return "Pointer"
		case .unknown(let val)	: return XGScriptClass.classes(val).name
		}
	}
	
	var index: Int {
		switch self {
		case .void		    	: return 0
		case .integer			: return 1
		case .float				: return 2
		case .string			: return 3
		case .vector			: return 4
		case .matrix			: return 5
		case .object			: return 6
		case .array				: return 7
		#if GAME_XD
		case .text				: return 8
		case .character			: return 35
		case .index			: return 37
		#endif
		case .codePointer		: return 53
		case .unknown(let val)	: return val
		}
	}
	
	static func typeWithIndex(_ id: Int) -> XDSConstantTypes {
		switch id {
		case  0: return .void
		case  1: return .integer
		case  2: return .float
		case  3: return .string
		case  4: return .vector
		case  5: return .matrix
		case  6: return .object
		case  7: return .array
		#if GAME_XD
		case  8: return .text
		case 35: return .character
		case 37: return .index
		#endif
		case 53: return .codePointer
		default: return .unknown(id)
		}
	}
	
	static func typeWithName(_ name: String) -> XDSConstantTypes? {
		
		// not sure of actual number of types but should be fewer than 100
		for i in 0 ..< 100 {
			let type = XDSConstantTypes.typeWithIndex(i)
			if type.string == name {
				return type
			}
		}
		return nil
	}

}

class XDSConstant : NSObject {
	
	var type: XDSConstantTypes = .void
	var value: UInt32 = 0

	var stringTable: XGStringTable?
	
	override var description: String {
		
		var val = ""
		
		switch self.type {
		case .float:
			val = String(format: "%.2f", self.asFloat)
		default:
			val = "\(self.asInt)"
		}
		
		return self.type.string + "(" + val + ")"
	}
	
	var asFloat: Float {
		return value.hexToSignedFloat()
	}
	
	var asInt: Int {
		return value.int32
	}
	
	var rawValueString: String {
		switch self.type {
		case .float:
			var text = String(format: "%.4f", self.asFloat)
			if !text.contains(".") {
				text += ".0"
			}
			while text.last == "0" {
				text.removeLast()
			}
			if text.last == "." {
				text += "0"
			}
			return text
		#if GAME_XD
		case .index:
			let mid = self.asInt == 0 ? "" : "\(self.asInt)"
			return "Pokemon(\(mid))"
		#endif
		case .string:
			return "String(\(self.asInt))"
		case .vector:
			return "vector_" + String(format: "%02d", self.asInt)
		case .integer:
			return self.asInt >= 0x200 ? self.asInt.hexString() : "\(self.asInt)"
		case .void:
			return "Null"
		case .array:
			return "array_" + String(format: "%02d", self.asInt)
		case .matrix:
			return "matrix_" + String(format: "%02d", self.asInt)
		case .object:
			return "Object(\(self.asInt))"
		#if GAME_XD
		case .text:
			if let table = self.stringTable {
				if let string = table.stringWithID(self.asInt) {
					return XDSExpr.msgMacro(string).text(isCommonScript: false)[0]
				}
			}
			return XDSExpr.msgMacro(getStringSafelyWithID(id: self.asInt)).text(isCommonScript: false)[0]

		case .character:
			return XGScriptInstruction(bytes: 0x03030080 + UInt32(self.asInt), next: 0).XDSVariable
		#endif
		case .codePointer:
			#if GAME_XD
			return XDSExpr.locationIndex(self.asInt).text(isCommonScript: false)[0]
			#else
			return XDSExpr.locationIndex(self.asInt).text[0]
			#endif
		case .unknown(let i):
			let mid = self.asInt == 0 ? "" : "\(self.asInt)"
			return XGScriptClass.classes(i).name + "(\(mid))"
		}
	}
	
	init(type: Int, rawValue: UInt32) {
		super.init()
		
		self.type = XDSConstantTypes.typeWithIndex(type)
		self.value = rawValue
		
	}
	
	convenience init(type: XDSConstantTypes, rawValue: Int) {
		self.init(type: type.index, rawValue: rawValue.unsigned)
	}
	
	var expression : XDSExpr {
		return .loadImmediate(self)
	}
	
	class var null : XDSConstant {
		return XDSConstant(type: 0, rawValue: 0)
	}
	
	class func integer(_ val: Int) -> XDSConstant {
		return XDSConstant(type: XDSConstantTypes.integer.index, rawValue: val.unsigned)
	}
	
	class func integer(_ val: UInt32) -> XDSConstant {
		return XDSConstant(type: XDSConstantTypes.integer.index, rawValue: val)
	}
	
	class func float(_ val: Float) -> XDSConstant {
		return XDSConstant(type: XDSConstantTypes.float.index, rawValue: val.floatToHex())
	}
}




























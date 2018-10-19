//
//  XDSConstant.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

enum XDSConstantTypes {

	// same as classes in script class info
	case none_t
	case integer		
	case float			
	case string			
	case vector			
	case array
	case msg			
	case character		
	case pokemon
	case codeptr_t
	case unknown(Int)
	
	var string : String {
		get {
			switch self {
				case .none_t			: return "Type_null"
				case .integer			: return "Int"
				case .float				: return "Float"
				case .string			: return "String"
				case .vector			: return "Vector"
				case .array				: return "Array"
				case .msg				: return "Msg"
				case .character			: return "Character"
				case .pokemon			: return "Pokemon"
				case .codeptr_t			: return "Pointer"
				case .unknown(let val)	: return XGScriptClassesInfo.classes(val).name
			}
		}
	}
	
	var index : Int {
		switch self {
		case .none_t			: return 0
		case .integer			: return 1
		case .float				: return 2
		case .string			: return 3
		case .vector			: return 4
		case .array				: return 7
		case .msg				: return 8
		case .character			: return 35
		case .pokemon			: return 37
		case .codeptr_t			: return 53
		case .unknown(let val)	: return val
		}
	}
	
	static func typeWithIndex(_ id: Int) -> XDSConstantTypes {
		switch id {
			case  0 : return .none_t
			case  1 : return .integer
			case  2 : return .float
			case  3 : return .string
			case  4 : return .vector
			case  7 : return .array
			case  8 : return .msg
			case 35 : return .character
			case 37 : return .pokemon
			case 53 : return .codeptr_t
			default : return .unknown(id)
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
	
	var type   : XDSConstantTypes = .none_t
	@objc var value  : UInt32 = 0
	
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
	
	@objc var asFloat : Float {
		return value.hexToSignedFloat()
	}
	
	@objc var asInt : Int {
		return value.int32
	}
	
	@objc var rawValueString : String {
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
		case .pokemon:
			let mid = self.asInt == 0 ? "" : "\(self.asInt)"
			return "Pokemon(\(mid))"
		case .string:
			return "String(\(self.asInt))"
		case .vector:
			return "vector_" + String(format: "%02d", self.asInt)
		case .integer:
			return self.asInt >= 0x200 ? self.asInt.hexString() : "\(self.asInt)"
		case .none_t:
			return "Null"
		case .array:
			return "array_" + String(format: "%02d", self.asInt)
		case .msg:
			return XDSExpr.msgMacro(getStringSafelyWithID(id: self.asInt)).text
		case .character:
			return XGScriptInstruction(bytes: 0x03030080 + UInt32(self.asInt), next: 0).XDSVariable
		case .codeptr_t:
			return XDSExpr.locationIndex(self.asInt).text
		case .unknown(let i):
			let mid = self.asInt == 0 ? "" : "\(self.asInt)"
			return XGScriptClassesInfo.classes(i).name.capitalized + "(\(mid))"
		}
	}
	
	@objc init(type: Int, rawValue: UInt32) {
		super.init()
		
		self.type = XDSConstantTypes.typeWithIndex(type)
		self.value = rawValue
		
		
	}
	
	var expression : XDSExpr {
		return .loadImmediate(self)
	}
	
	@objc class var null : XDSConstant {
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




























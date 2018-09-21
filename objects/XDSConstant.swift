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
				case .none_t			: return "None"
				case .integer			: return "Int"
				case .float				: return "Float"
				case .string			: return "String"
				case .vector			: return "Vector"
				case .array				: return "Array"
				case .msg				: return "Msg"
				case .character			: return "Character"
				case .pokemon			: return "Pokemon"
				case .codeptr_t			: return "Pointer"
				case .unknown(let val)	: return "UnknownType\(val)"
			}
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

}

class XDSConstant : NSObject {
	
	var type   : XDSConstantTypes = .none_t
	@objc var value  : UInt32 = 0
	
	override var description: String {
		
		var val = ""
		
		switch self.type {
		case .float:
			val = String(format: "%.2f",self.asFloat)
		case .pokemon:
			val = "\(XGPokemon.pokemon(self.asInt).name.string)"
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
			return String(format: "%.2f", self.asFloat)
		case .pokemon:
			return "Pokemon(\(self.asInt))"
		case .string:
			return "String(\(self.asInt))"
		case .vector:
			return "vector_" + String(format: "%02d", self.asInt)
		case .integer:
			return "\(self.asInt)"
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
			return XGScriptClassesInfo.classes(i).name + "(\(self.asInt))"
		}
	}
	
	@objc init(type: Int, rawValue: UInt32) {
		super.init()
		
		self.type = XDSConstantTypes.typeWithIndex(type)
		self.value = rawValue
		
		
	}
	
	@objc class var null : XDSConstant {
		return XDSConstant(type: 0, rawValue: 0)
	}
}




























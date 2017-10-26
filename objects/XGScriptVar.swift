//
//  XGScriptVar.swift
//  XGCommandLineTools
//
//  Created by StarsMmd on 21/05/2016.
//  Copyright © 2016 StarsMmd. All rights reserved.
//

import Foundation

enum XGScriptVarTypes {

	case none_t
	case integer		
	case float			
	case string			
	case vector			
	case list			
	case msg			
	case character		
	case pokemon		
	case unknowntype44	
	case codeptr_t
	case unknown(Int)
	
	var string : String {
		get {
			switch self {
				case .none_t			: return "none_t"
				case .integer			: return "integer"
				case .float				: return "float"
				case .string			: return "string"
				case .vector			: return "vector"
				case .list				: return "list"
				case .msg				: return "msg"
				case .character			: return "character"
				case .pokemon			: return "pokemon"
				case .unknowntype44		: return "unknowntype44"
				case .codeptr_t			: return "codeptr_t"
				case .unknown(let val)	: return "unknowntype\(val)"
			}
		}
	}
	
	static func typeWithIndex(_ id: Int) -> XGScriptVarTypes {
		switch id {
			case  0 : return .none_t
			case  1 : return .integer
			case  2 : return .float
			case  3 : return .string
			case  4 : return .vector
			case  7 : return .list
			case  8 : return .msg
			case 35 : return .character
			case 37 : return .pokemon
			case 44 : return .unknowntype44
			case 53 : return .codeptr_t
			default : return .unknown(id)
		}
	}

}

class XGScriptVar : NSObject {
	
	var type   : XGScriptVarTypes = .none_t
	var value  : UInt32 = 0
	
	override var description: String {
		
		var val = ""
		
		switch self.type {
		case .float:
			val = "\(self.value.hexToSignedFloat())"
		default:
			val = "\(self.value.int)"
		}
		
		return self.type.string + "(" + val + ")"
	}
	
	var asFloat : Float {
		return value.hexToSignedFloat()
	}
	
	var asInt : Int {
		return Int(value)
	}
	
	init(type: Int, rawValue: UInt32) {
		super.init()
		
		self.type = XGScriptVarTypes.typeWithIndex(type)
		self.value = rawValue
		
		
	}
	
}




























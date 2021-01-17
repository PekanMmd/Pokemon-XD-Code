//
//  XDSConstant.swift
//  Revolution Tool CL
//
//  Created by The Steez on 26/12/2018.
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
	case codePointer
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
			case .codePointer		: return "Pointer"
			case .unknown(let val)	: return "Class\(val)"
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
		case .codePointer	: return 8
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
		case  8 : return .codePointer
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
	var value  : UInt32 = 0
	
	override var description: String {
		return self.rawValueString
	}
	
	var asFloat : Float {
		return value.hexToSignedFloat()
	}
	
	var asInt : Int {
		return value.int32
	}
	
	var rawValueString : String {
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
		case .codePointer:
			return XDSExpr.locationIndex(self.asInt).text[0]
		case .unknown(let i):
			return XGScriptClass.classes(i).name + "(\(self.asInt))"
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

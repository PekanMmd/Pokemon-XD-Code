//
//  CMScriptValueTypes.swift
//  GoD Tool
//
//  Created by Stars Momodu on 12/10/2020.
//

import Foundation

enum CMScriptValueTypes: Equatable {

	case none
	case integer
	case float
	case unknown(id: Int)

	var id: Int {
		switch self {
		case .none:
			return 0
		case .integer:
			return 2
		case .float:
			return 3
		case .unknown(id: let id):
			return id
		}
	}

	var name: String {
		switch self {
		case .none: return "None"
		case .integer: return "Int"
		case .float: return "Float"
		case .unknown(id: let id): return "Type\(id)"
		}
	}

	static func fromID(_ id: Int) -> CMScriptValueTypes {
		for type: CMScriptValueTypes in [.none, .integer, .float] {
			if type.id == id {
				return type
			}
		}
		return .unknown(id: id)
	}

}

struct CMScriptVar: CustomStringConvertible {

	let type: CMScriptValueTypes
	let flag0x100: Bool // If set, treat the value as a pointer and dereference it
	let flag0x80: Bool  // If set, pop the top value from the stack, ignore other flags
	let flag0x40: Bool
	let flag0x20: Bool

	var mask: Int {
		var val = type.id
		if flag0x100 { val += 0x100 }
		if flag0x80 { val += 0x80 }
		if flag0x40 { val += 0x40 }
		if flag0x20 { val += 0x20 }
		return val
	}

	var varType: String {
		if flag0x80 {
			return "StackPop"
		}
		if flag0x40 && flag0x20 {
			return "Var60"
		}

		if flag0x20 {
			return "Var20"
		}

		if flag0x40 {
			return "Var40"
		}

		if (!flag0x100 && !flag0x80 && !flag0x40 && !flag0x20) {
			return "Var00"
		}

		return "InvalidVar(\(mask.hex()))"
	}

	var description: String {
		if type == .none {
			return "Null"
		}
		let pointer = flag0x100 ? "Pointer:" : ""
		return pointer + type.name + "(\(varType))"
	}

	static func fromMask(_ mask: Int) -> CMScriptVar {
		let typeID = mask & 0x3f
		let flag0x20 = (mask & 0x20) > 0
		let flag0x40 = (mask & 0x40) > 0
		let flag0x80 = (mask & 0x80) > 0
		let flag0x100 = (mask & 0x100) > 0
		return .init(type: .fromID(typeID), flag0x100: flag0x100, flag0x80: flag0x80, flag0x40: flag0x40, flag0x20: flag0x20)
	}

	static func fromMask(_ mask: UInt8) -> CMScriptVar {
		return .fromMask(Int(mask))
	}
}

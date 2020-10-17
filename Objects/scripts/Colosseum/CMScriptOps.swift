//
//  CMEXpr.swift
//  GoD Tool
//
//  Created by Stars Momodu on 06/10/2020.
//

import Foundation

enum XGScriptOps: CustomStringConvertible {

	case nop
	case exit
	case pushMinus1 // Seems to push -1 onto the stack
	case pop(unused: CMScriptVar, count: UInt16)
	case call(functionID: UInt32, unknown1: UInt16, unknown2: UInt16)
	case return_op
	case jump(offset: UInt32)
	case jumpFalse(offset: UInt32)
	case push(type: UInt8, value: UInt32)
	case and(var1: CMScriptVar, var2: CMScriptVar)
	case or(var1: CMScriptVar, var2: CMScriptVar)
	case pushVar(var1: CMScriptVar)
	case unknown16(var1: CMScriptVar, count: UInt16) // Maybe set var?
	case not(var1: CMScriptVar)
	case negate(var1: CMScriptVar)
	case pushVar2(var1: CMScriptVar) // Doesn't seem to perform any operation on the variable
	case multiply(var1: CMScriptVar, var2: CMScriptVar)
	case divide(var1: CMScriptVar, var2: CMScriptVar)
	case mod(var1: CMScriptVar, var2: CMScriptVar)
	case add(var1: CMScriptVar, var2: CMScriptVar)
	case subtract(var1: CMScriptVar, var2: CMScriptVar)
	case greaterThan(var1: CMScriptVar, var2: CMScriptVar)
	case greaterThanEqual(var1: CMScriptVar, var2: CMScriptVar) // educated guess but not sure
	case lessThan(var1: CMScriptVar, var2: CMScriptVar)
	case lessThanEqual(var1: CMScriptVar, var2: CMScriptVar) // educated guess but not sure
	case equal(var1: CMScriptVar, var2: CMScriptVar)
	case notEqual(var1: CMScriptVar, var2: CMScriptVar)
	case unknown31(var1: CMScriptVar, var2: CMScriptVar)
	case unknown32(var1: CMScriptVar, var2: CMScriptVar)
	case unknown33(var1: CMScriptVar, var2: CMScriptVar)
	case unknown34(var1: CMScriptVar, var2: CMScriptVar)
	case unknown35(unused: UInt16, unknown: UInt16)
	case unknown36(unused: UInt16, unknown: UInt16)
	case callStandard(unused: UInt16, argCount: UInt16)
	case invalid(id: Int)

	var opCode: Int {
		switch self {
		case .nop:				return 0
		case .exit:				return 1
		case .pushMinus1:		return 2
		case .pop:				return 3
		case .call: 			return 4
		case .return_op: 		return 5
		case .jump: 			return 6
		case .jumpFalse: 		return 7
		case .push: 			return 8
		// 9-12 are invalid
		case .and:		return 13
		case .or:		return 14
		case .pushVar:		return 15
		case .unknown16: 		return 16
		case .not: 		return 17
		case .negate: 		return 18
		case .pushVar2: 		return 19
		case .multiply: 		return 20
		case .divide: 		return 21
		case .mod: 		return 22
		case .add: 		return 23
		case .subtract: 		return 24
		case .greaterThan: 		return 25
		case .greaterThanEqual: 		return 26
		case .lessThan: 		return 27
		case .lessThanEqual: 		return 28
		case .equal:		return 29
		case .notEqual: 		return 30
		case .unknown31: 		return 31
		case .unknown32: 		return 32
		case .unknown33: 		return 33
		case .unknown34: 		return 34
		case .unknown35: 		return 35
		case .unknown36: 		return 36
		case .callStandard: 	return 37
		case .invalid(let id): 	return id
		}
	}

	var length: Int {
		switch self {
		case .nop: return 1
		case .exit: return 1
		case .pushMinus1: return 1
		case .pop: return 4
		case .call: return 9
		case .return_op: return 1
		case .jump:  return 5
		case .jumpFalse:  return 5
		case .push: return 6
		case .and: return 3
		case .or: return 3
		case .pushVar: return 2
		case .unknown16: return 4
		case .not: return 2
		case .negate: return 2
		case .pushVar2: return 2
		case .multiply: return 3
		case .divide: return 3
		case .mod: return 3
		case .add: return 3
		case .subtract: return 3
		case .greaterThan: return 3
		case .greaterThanEqual: return 3
		case .lessThan: return 3
		case .lessThanEqual: return 3
		case .equal: return 3
		case .notEqual: return 3
		case .unknown31: return 3
		case .unknown32: return 3
		case .unknown33: return 3
		case .unknown34: return 3
		case .unknown35: return 5
		case .unknown36: return 5
		case .callStandard: return 5
		case .invalid: return 1
		}
	}

	var description: String {
		switch self {
		case .nop:
			return "Nop"
		case .exit:
			return "Exit"
		case .pushMinus1:
			return "PushMinus1"
		case .pop(_, count: let count):
			return "Pop \(count)"
		case .call(functionID: let functionID, unknown1: let unknown1, unknown2: let unknown2):
			return "Call @function_\(functionID) (\(unknown1), \(unknown2))"
		case .return_op:
			return "Return"
		case .jump(offset: let offset):
			return "Jump @\(offset.hex())"
		case .jumpFalse(offset: let offset):
			return "JumpFalse @\(offset.hex())"
		case .push(type: let type, value: let value):
			let valueString: String
			switch (CMScriptValueTypes.fromID(Int(type))) {
			case .integer:
				valueString = value.int32 > 0xFF ? value.int32.hexString() : value.int32.string
			case .float:
				valueString = value.hexToSignedFloat().string
			default:
				valueString = value.hexString() + " (type: \(type))"
			}
			return "Push \(valueString)"
		case .and(var1: let var1, var2: let var2):
			return "\(var1) & \(var2)"
		case .or(var1: let var1, var2: let var2):
			return "\(var1) | \(var2)"
		case .pushVar(var1: let var1):
			return "PushVar \(var1)"
		case .unknown16(var1: let var1, count: let count):
			return "Op16 \(var1) \(count)"
		case .not(var1: let var1):
			return "!\(var1)"
		case .negate(var1: let var1):
			return "-\(var1)"
		case .pushVar2(var1: let var1):
			return "PushVar2 \(var1)"
		case .multiply(var1: let var1, var2: let var2):
			return "\(var1) * \(var2)"
		case .divide(var1: let var1, var2: let var2):
			return "\(var1) / \(var2)"
		case .mod(var1: let var1, var2: let var2):
			return "\(var1) % \(var2)"
		case .add(var1: let var1, var2: let var2):
			return "\(var1) + \(var2)"
		case .subtract(var1: let var1, var2: let var2):
			return "\(var1) - \(var2)"
		case .greaterThan(var1: let var1, var2: let var2):
			return "\(var1) > \(var2)"
		case .greaterThanEqual(var1: let var1, var2: let var2):
			return "\(var1) >= \(var2)"
		case .lessThan(var1: let var1, var2: let var2):
			return "\(var1) < \(var2)"
		case .lessThanEqual(var1: let var1, var2: let var2):
			return "\(var1) <= \(var2)"
		case .equal(var1: let var1, var2: let var2):
			return "\(var1) = \(var2)"
		case .notEqual(var1: let var1, var2: let var2):
			return "\(var1) != \(var2)"
		case .unknown31(var1: let var1, var2: let var2):
			return "Op31 \(var1) \(var2)"
		case .unknown32(var1: let var1, var2: let var2):
			return "Op32 \(var1) \(var2)"
		case .unknown33(var1: let var1, var2: let var2):
			return "Op33 \(var1) \(var2)"
		case .unknown34(var1: let var1, var2: let var2):
			return "Op34 \(var1) \(var2)"
		case .unknown35(unused: let unused, unknown: let unknown):
			return "Op35 \(unknown) (\(unused))"
		case .unknown36(unused: let unused, unknown: let unknown):
			return "Op36 \(unknown) (\(unused))"
		case .callStandard(unused: let unused, argCount: let argCount):
			return "CallStandard argc:\(argCount) (\(unused))"
		case .invalid(id: let id):
			return "Invalid OpCpde (\(id))"
		}
	}

	var argCount: Int {
		switch self {
		case .callStandard(_, argCount: let argc): return Int(argc)
		default: return 0
		}
	}
}

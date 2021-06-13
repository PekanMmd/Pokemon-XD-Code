//
//  CMScriptOps.swift
//  GoD Tool
//
//  Created by Stars Momodu on 06/10/2020.
//

import Foundation

enum CMScriptOps: CustomStringConvertible {

	case nop
	case exit // Possibly only used to mark the last instruction of the entire script
	case pushMinus1 // Seems to push -1 onto the stack
	case pop(unused: CMScriptVar, count: UInt16)
	case call(functionID: UInt32, returnCount: UInt16, argCount: UInt16)
	case return_op
	case jump(offset: UInt32)
	case jumpFalse(offset: UInt32)
	case pushImmediate(type: CMScriptValueTypes, value: UInt32) // pushes a literal value
	case and(var1: CMScriptVar, var2: CMScriptVar) // arithmetic and
	case or(var1: CMScriptVar, var2: CMScriptVar) // arithmetic or
	case pushVar(var1: CMScriptVar)
	case pushMultiVar(var1: CMScriptVar, count: UInt16) // pushes a var multiple times. Seems to be used instead of pushVar even if count is 1
	case not(var1: CMScriptVar)
	case negate(var1: CMScriptVar)
	case pushVar2(var1: CMScriptVar) // Doesn't seem to perform any operation on the variable
	case multiply(var1: CMScriptVar, var2: CMScriptVar)
	case divide(var1: CMScriptVar, var2: CMScriptVar)
	case mod(var1: CMScriptVar, var2: CMScriptVar)
	case add(var1: CMScriptVar, var2: CMScriptVar)
	case subtract(var1: CMScriptVar, var2: CMScriptVar)
	case lessThan(var1: CMScriptVar, var2: CMScriptVar)
	case lessThanEqual(var1: CMScriptVar, var2: CMScriptVar) // educated guess but not sure
	case greaterThan(var1: CMScriptVar, var2: CMScriptVar)
	case greaterThanEqual(var1: CMScriptVar, var2: CMScriptVar) // educated guess but not sure
	case equal(var1: CMScriptVar, var2: CMScriptVar)
	case notEqual(var1: CMScriptVar, var2: CMScriptVar)
	case setVar(source: CMScriptVar, target: CMScriptVar)
	case copyStruct(source: CMScriptVar, destination: CMScriptVar, length: UInt16)
	case andl(var1: CMScriptVar, var2: CMScriptVar) // logical and
	case orl(var1: CMScriptVar, var2: CMScriptVar) // logical or
	case printf(unused: UInt16, argCount: UInt16) // number of interpolated arguments to read from stack, followed by string pointer. Last arg at top of stack
	case yield(unused: UInt16, argCount: UInt16)
	case callStandard(returnCount: UInt16, argCount: UInt16)
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
		case .pushImmediate: 			return 8
		// 9-12 are invalid
		case .and:		return 13
		case .or:		return 14
		case .pushVar:		return 15
		case .pushMultiVar: 		return 16
		case .not: 		return 17
		case .negate: 		return 18
		case .pushVar2: 		return 19
		case .multiply: 		return 20
		case .divide: 		return 21
		case .mod: 		return 22
		case .add: 		return 23
		case .subtract: 		return 24
		case .lessThan: 		return 25
		case .lessThanEqual: 		return 26
		case .greaterThan: 		return 27
		case .greaterThanEqual: 		return 28
		case .equal:		return 29
		case .notEqual: 		return 30
		case .setVar: 		return 31
		case .copyStruct: 		return 32
		case .andl: 		return 33
		case .orl: 		return 34
		case .printf: 		return 35
		case .yield: 		return 36
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
		case .pushImmediate: return 6
		case .and: return 3
		case .or: return 3
		case .pushVar: return 2
		case .pushMultiVar: return 4
		case .not: return 2
		case .negate: return 2
		case .pushVar2: return 2
		case .multiply: return 3
		case .divide: return 3
		case .mod: return 3
		case .add: return 3
		case .subtract: return 3
		case .lessThan: return 3
		case .lessThanEqual: return 3
		case .greaterThan: return 3
		case .greaterThanEqual: return 3
		case .equal: return 3
		case .notEqual: return 3
		case .setVar: return 3
		case .copyStruct: return 5
		case .andl: return 3
		case .orl: return 3
		case .printf: return 5
		case .yield: return 5
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
		case .call(functionID: let functionID, returnCount: let returnCount, argCount: let argCount):
			return "CallFromScript function\(functionID)(argc:\(argCount)) -> returns:\(returnCount)"
		case .return_op:
			return "Return"
		case .jump(offset: let offset):
			return "Jump @\(offset.hex())"
		case .jumpFalse(offset: let offset):
			return "JumpFalse @\(offset.hex())"
		case .pushImmediate(type: let type, value: let value):
			let valueString: String
			switch type {
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
		case .pushMultiVar(var1: let var1, count: let count):
			return "PushMultiVar \(var1) x\(count)"
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
		case .lessThan(var1: let var1, var2: let var2):
			return "\(var1) > \(var2)"
		case .lessThanEqual(var1: let var1, var2: let var2):
			return "\(var1) >= \(var2)"
		case .greaterThan(var1: let var1, var2: let var2):
			return "\(var1) < \(var2)"
		case .greaterThanEqual(var1: let var1, var2: let var2):
			return "\(var1) <= \(var2)"
		case .equal(var1: let var1, var2: let var2):
			return "\(var1) == \(var2)"
		case .notEqual(var1: let var1, var2: let var2):
			return "\(var1) != \(var2)"
		case .setVar(source: let source, target: let target):
			return "SetVar \(target) to value of: \(source)"
		case .copyStruct(source: let source, destination: let destination, let length):
			return "Copy \(length) bytes from \(source) to \(destination)"
		case .andl(var1: let var1, var2: let var2):
			return "\(var1) && \(var2)"
		case .orl(var1: let var1, var2: let var2):
			return "\(var1) || \(var2)"
		case .printf(_, argCount: let unknown):
			return "Print_f argc:\(unknown)"
		case .yield(_, argCount: let count):
			return "Yield frames: x\(count)"
		case .callStandard(_, argCount: let argCount):
			return "CallStandard argc:\(argCount)"
		case .invalid(id: let id):
			return "Invalid OpCpde (\(id))"
		}
	}

	var argCount: Int {
		switch self {
		case .printf(_, let argc): return Int(argc)
		case .callStandard(_, argCount: let argc): return Int(argc)
		default: return 0
		}
	}
}

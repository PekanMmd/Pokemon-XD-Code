//
//  XDSMacroTypes.swift
//  GoD Tool
//
//  Created by The Steez on 03/06/2018.
//

import Foundation

func ==(lhs: XDSMacroTypes, rhs: XDSMacroTypes) -> Bool {
	return lhs.index == rhs.index
}
func !=(lhs: XDSMacroTypes, rhs: XDSMacroTypes) -> Bool {
	return lhs.index != rhs.index
}
func <(lhs: XDSMacroTypes, rhs: XDSMacroTypes) -> Bool {
	return lhs.index < rhs.index
}
func >(lhs: XDSMacroTypes, rhs: XDSMacroTypes) -> Bool {
	return lhs.index > rhs.index
}
func <=(lhs: XDSMacroTypes, rhs: XDSMacroTypes) -> Bool {
	return lhs.index <= rhs.index
}
func >=(lhs: XDSMacroTypes, rhs: XDSMacroTypes) -> Bool {
	return lhs.index >= rhs.index
}

enum XDSMacroTypes {
	
	case invalid
	case none
	
	// Types that can be replaced with macros
	case pokemon
	case item
	case model
	case move
	case room
	case flag
	case talk
	case ability
	case msgVar
	case battleResult
	case shadowStatus
	case pokespot
	case battleID
	case shadowID
	case treasureID
	case battlefield
	case partyMember
	case integerMoney
	case integerCoupons
	case integerQuantity
	case integerIndex
	case vectorDimension // x,y,z
	case giftPokemon
	case region
	case language
	case PCBox
	
	// replaced with special macro but not added as a define statement
	case msg
	case bool
	
	// Types simply used for documentation but are printed as raw values
	case integer
	case float
	case integerFloatOverload // accepts either an integer or a float
	case integerAngleDegrees
	case floatAngleDegrees
	case floatAngleRadians
	case floatFraction // between 0.0 and 1.0
	case integerByte
	case integerUnsigned
	
	case vector
	case array
	case arrayIndex
	case string // not msgs, raw strings used mainly by printf for debugging
	case anyType // rare but some functions can take any value as parameter, usually when it is unused
	case object(Int) // value of class type 33 or higher, same type as the class calling the function
	case objectName(String) // same as object but specified by its name instead of index for convenience
	
	var index : Int {
		switch self {
			
		case .invalid: return -1
			
		case .none: return 0
		case .pokemon: return 1
		case .item: return 2
		case .model: return 3
		case .move: return 4
		case .room: return 5
		case .flag: return 6
		case .talk: return 7
		case .ability: return 8
		case .msgVar: return 9
		case .battleResult: return 10
		case .shadowStatus: return 11
		case .pokespot: return 12
		case .battleID: return 13
		case .shadowID: return 14
		case .treasureID: return 15
		case .battlefield: return 16
		case .partyMember: return 17
		case .integerMoney: return 18
		case .integerCoupons: return 19
		case .integerQuantity: return 20
		case .integerIndex: return 21
		case .vectorDimension: return 22
		case .giftPokemon: return 23
		case .region: return 24
		case .language: return 25
		case .PCBox: return 26
			
		// leave a gap in case of future additions
		case .msg: return 100
		case .bool: return 101
			
		// another gap for same reason
		case .integer: return 200
		case .float: return 201
		case .integerFloatOverload: return 202
		case .integerAngleDegrees: return 203
		case .floatAngleDegrees: return 204
		case .floatAngleRadians: return 205
		case .floatFraction: return 206
		case .integerByte: return 207
		case .integerUnsigned: return 208
			
		// more gaps
		case .vector: return 300
		case .array: return 301
		case .arrayIndex: return 302
		case .string: return 303
			
		// I hope you like gaps
		case .anyType: return 499
		case .object(let cid): return 500 + cid
		case .objectName(let s):
			if let type = XGScriptClass.getClassNamed(s) {
				return XDSMacroTypes.object(type.index).index
			} else {
				printg("Unknown macro type class: \(s)")
				return -2
			}
		}
	}
	
	var needsDefine : Bool {
		return self < XDSMacroTypes.msg && self > XDSMacroTypes.none
	}
	
	var printsAsMacro : Bool {
		return self < XDSMacroTypes.integer && self > XDSMacroTypes.none
	}
	
}

let kNumberOfTalkTypes = 22
enum XDSTalkTypes : Int {
	
	case none				= 0
	case normal				= 1
	case approachThenSpeak	= 2
	case promptYesNoBool	= 3 // yes = 1, no = 0
	case battle1			= 6
	case promptYesNoIndex	= 8 // yes = 0, no = 1
	case battle2			= 9
	case silentItem			= 14
	case speciesCry			= 15
	case silentText			= 16
	
	var extraMacro : XDSMacroTypes? {
		switch self {
		case .silentItem: return .item
		case .speciesCry: return .pokemon
		case .battle1: return .battleID
		case .battle2: return .battleID
		default: return nil
		}
	}
	
	var extraMacro2 : XDSMacroTypes? {
		switch self {
		case .silentItem: return .integerQuantity
		case .speciesCry: return .msg
		default: return nil
		}
	}
	
	var string : String {
		switch self {
		case .none				: return "none"
		case .normal			: return "normal"
		case .approachThenSpeak	: return "approach"
		case .promptYesNoBool		: return "yes_no"
		case .battle1			: return "battle_alt"
		case .battle2			: return "battle"
		case .silentItem		: return "get_item"
		case .speciesCry		: return "species_cry"
		case .silentText		: return "silent"
		case .promptYesNoIndex	: return "yes_no_index"
		}
	}
}

enum XDSMSGVarTypes : Int {
	case pokemon = 0x4e
	case item = 0x2d
	// incomplete but unnecessary. full list in xgspecialstringcharacter
	
	static func macroForVarType(_ type: Int) -> XDSMacroTypes? {
		switch type {
			
		case 0x0f: fallthrough
		case 0x10: fallthrough
		case 0x11: fallthrough
		case 0x12: return .pokemon
			
		case 0x16: fallthrough
		case 0x17: fallthrough
		case 0x18: fallthrough
		case 0x19: return .pokemon
			
		case 0x1a: fallthrough
		case 0x1b: fallthrough
		case 0x1c: fallthrough
		case 0x1d: return .ability
			
		case 0x1e: fallthrough
			
		case 0x20: fallthrough
		case 0x21: return .pokemon
			
		case 0x28: return .move
			
		case 0x29: fallthrough
		case 0x2d: fallthrough
		case 0x2e: return .item
			
		case 0x2f: return nil // item quantity
			
		case 0x4d: return .msg
			
		case 0x4e: return .pokemon
			
		default: return nil
		}
	}
}

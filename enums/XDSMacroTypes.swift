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

indirect enum XDSMacroTypes {
	
	case invalid
	case null
	
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
	case transitionID
	case yesNoIndex
	case scriptFunction
	case sfxID
    case storyProgress
	
	case array(XDSMacroTypes)
	
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
	case integerUnsignedByte
	case integerUnsigned
	case integerBitMask
	case datsIdentifier // id for a .dats model archive]
	case camIdentifier // id for a .cam file
	
	case vector
	case arrayIndex
	case string // not msgs, raw strings used mainly by printf for debugging
	case list(XDSMacroTypes) // multiple parameters of an unspecified number
	case anyType // rare but some functions can take any value as parameter, usually when it is unused
	case variableType // the type may vary depending on the other parameters
	case optional(XDSMacroTypes) // may be included or discluded
	case object(Int) // value of class type 33 or higher, same type as the class calling the function
	case objectName(String) // same as object but specified by its name instead of index for convenience
	
	var index : Int {
		switch self {
			
		case .invalid: return -1
			
		case .null: return 0
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
		case .transitionID: return 27
		case .yesNoIndex: return 28
		case .scriptFunction: return 29
		case .sfxID: return 30
        case .storyProgress: return 31
			
		case .array: return 99
			
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
		case .integerUnsignedByte: return 208
		case .integerUnsigned: return 209
		case .integerBitMask: return 210
		case .datsIdentifier: return 211
		case .camIdentifier: return 212
			
		// more gaps
		case .vector: return 300
		case .arrayIndex: return 301
		case .string: return 302
		case .list: return 303
			
		// I hope you like gaps
		case .optional: return 497
		case .variableType: return 498
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
	
	var macroType : XDSMacroTypes {
		switch self {
		case .array(let t):
			return t
		case .optional(let t):
			return t
		default:
			return self
		}
	}
	
	var needsDefine : Bool {
		return self < XDSMacroTypes.msg && self > XDSMacroTypes.null
	}
	
	var printsAsMacro : Bool {
		return self < XDSMacroTypes.integer && self > XDSMacroTypes.null
	}
	
	var printsAsHexadecimal : Bool {
		switch self {
		case .room:
			fallthrough
		case .battlefield:
			fallthrough
		case .scriptFunction:
			fallthrough
		case .integerUnsigned:
			fallthrough
		case .datsIdentifier:
			fallthrough
		case .camIdentifier:
			fallthrough
		case .flag:
			fallthrough
		case .integerBitMask:
			fallthrough
		case .invalid:
			fallthrough
		case .model:
			return true
		case .optional(let t):
			return t.printsAsHexadecimal
		case .list(let t):
			return t.printsAsHexadecimal
		case .array(let t):
			return t.printsAsHexadecimal
		default:
			return false
		}
	}
	
	var typeName : String {
		switch self {
		case .invalid:
			return "Invalid"
		case .null:
			return "Null"
		case .pokemon:
			return "PokemonID"
		case .item:
			return "ItemID"
		case .model:
			return "ModelID"
		case .move:
			return "MoveID"
		case .room:
			return "RoomID"
		case .flag:
			return "FlagID"
		case .talk:
			return "SpeechType"
		case .ability:
			return "AbilityID"
		case .msgVar:
			return "MessageVariable"
		case .battleResult:
			return "BattleResult"
		case .shadowStatus:
			return "ShadowPokemonStatus"
		case .pokespot:
			return "PokespotID"
		case .battleID:
			return "BattleID"
		case .shadowID:
			return "ShadowPokemonID"
		case .treasureID:
			return "TreasureID"
		case .battlefield:
			return "RoomID"
		case .partyMember:
			return "NPCPartyMemberID"
		case .integerMoney:
			return "Pokedollars"
		case .integerCoupons:
			return "Pokecoupons"
		case .integerQuantity:
			return "Quantity"
		case .integerIndex:
			return "Index"
		case .yesNoIndex:
			return "YesNoIndex"
		case .scriptFunction:
			return "ScriptFunction"
		case .sfxID:
			return "SoundEffectID"
        case .storyProgress:
            return "StoryProgress"
		case .vectorDimension:
			return "VectorDimension"
		case .giftPokemon:
			return "GiftID"
		case .region:
			return "RegionID"
		case .language:
			return "LanguageID"
		case .PCBox:
			return "PCBoxID"
		case .transitionID:
			return "TransitionID"
		case .msg:
			return "StringID"
		case .bool:
			return "YesOrNo"
		case .integer:
			return "Integer"
		case .float:
			return "Decimal"
		case .integerFloatOverload:
			return "IntegerOrDecimal"
		case .integerAngleDegrees:
			return "Degrees"
		case .floatAngleDegrees:
			return "DecimalDegrees"
		case .floatAngleRadians:
			return "Radians"
		case .floatFraction:
			return "DecimalFromZeroToOne"
		case .integerByte:
			return "Signed8BitInteger"
		case .integerUnsignedByte:
			return "Unsigned8BitInteger"
		case .integerUnsigned:
			return "Unsigned32BitInteger"
		case .integerBitMask:
			return "IntegerBitMask"
		case .datsIdentifier:
			return "DatsID"
		case .camIdentifier:
			return "CameraRoutineID"
		case .vector:
			return "Vector"
		case .array(let t):
			return "Array[\(t.typeName)]"
		case .arrayIndex:
			return "ArrayIndex"
		case .string:
			return "String"
		case .list(let t):
			return "\(t.typeName) ..."
		case .variableType:
			return "TypeVaries"
		case .optional(let t):
			return "Optional(\(t.typeName))"
		case .anyType:
			return "AnyType"
		case .object(let id):
			let name = XGScriptClass.classes(id).name
			return "\(name)Object"
		case .objectName(let name):
			return "\(name)Object"
		}
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
		case .promptYesNoBool	: return "yes_no"
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
	// incomplete but unnecessary. full list in xgspecialstringcharacter
	case pokemon = 0x4e
	case item = 0x2d
	
	static func macroForVarType(_ type: Int) -> XDSMacroTypes? {
		switch type {
			
		case 0x0f: fallthrough
		case 0x10: fallthrough
		case 0x11: fallthrough
		case 0x12: fallthrough
			
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

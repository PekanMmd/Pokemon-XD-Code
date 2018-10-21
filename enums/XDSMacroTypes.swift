//
//  XDSMacroTypes.swift
//  GoD Tool
//
//  Created by The Steez on 03/06/2018.
//

import Foundation

enum XDSMacroTypes : Int {
	case none = 0
	case pokemon
	case pokemonNational
	case item
	case model
	case move
	case room
	case msg
	case flag
	case bool
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
}

enum XDSTalkTypes : Int {
	case normal				= 1
	case approachThenSpeak	= 2
	case promptYesNo		= 3
	case battle1			= 6
	case promptYesNo2		= 8
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
		case .silentItem: return .item
		default: return nil
		}
	}
	
	var string : String {
		switch self {
		case .normal			: return "normal"
		case .approachThenSpeak	: return "approach"
		case .promptYesNo		: return "yes_no"
		case .battle1			: return "battle_alt"
		case .battle2			: return "battle"
		case .silentItem		: return "get_item"
		case .speciesCry		: return "species_cry"
		case .silentText		: return "silent"
		case .promptYesNo2		: return "yes_no2"
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

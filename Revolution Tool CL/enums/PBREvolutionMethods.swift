//
//  XGEvolutionMethods.swift
//  XG Tool
//
//  Created by StarsMmd on 29/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGEvolutionMethods : Int, Codable, CaseIterable {
	
	case levelUpWithKeyItem		= -1
	
	case none					= 0x00
	case maxHappiness			= 0x01
	case happinessDay			= 0x02
	case happinessNight			= 0x03
	case levelUp				= 0x04
	case trade					= 0x05
	case tradeWithItem			= 0x06
	case evolutionStone			= 0x07
	case moreAttack				= 0x08
	case equalAttack			= 0x09
	case moreDefense			= 0x0A
	case silcoon				= 0x0B
	case cascoon				= 0x0C
	case ninjask				= 0x0D
	case shedinja				= 0x0E
	case maxBeauty				= 0x0F
	case evolutionStoneMale		= 0x10
	case evolutionStoneFemale	= 0x11
	case levelWithItemDay		= 0x12
	case levelWithItemNight		= 0x13
	case levelWithMove			= 0x14
	case levelWithPartyPokemon	= 0x15
	case levelUpMale			= 0x16
	case levelUpFemale			= 0x17
	case levelUpInMagneticField = 0x18
	case levelUpAtMossRock		= 0x19
	case levelUpAtIceRock		= 0x1a
	
	
	var string : String {
		get {
			switch self {
				case .levelUpWithKeyItem	: return "-"
				case .none					:	return "None"
				case .maxHappiness			:	return "Max Happiness"
				case .happinessDay			:	return "Happiness (Day)"
				case .happinessNight		:	return "Happiness (Night)"
				case .levelUp				:	return "Level Up"
				case .trade					:	return "Trade"
				case .tradeWithItem			:	return "Trade With Item"
				case .evolutionStone		:	return "Evolution Stone"
				case .moreAttack			:	return "Atk > Def"
				case .equalAttack			:	return "Atk = Def"
				case .moreDefense			:	return "Atk < Def"
				case .silcoon				:	return "Silcoon evolution method"
				case .cascoon				:	return "Cascoon evolution method"
				case .ninjask				:	return "Ninjask evolution method"
				case .shedinja				:	return "Shedinja evolution method"
				case .maxBeauty				:	return "Max Beauty"
				case .evolutionStoneMale	:	return "Evolution stone (male)"
				case .evolutionStoneFemale	:	return "Evolution stone (female)"
				case .levelWithItemDay		:	return "Level up holding item (day)"
				case .levelWithItemNight	:	return "Level up holding item (day)"
				case .levelWithMove			:	return "Level up with move learned"
				case .levelWithPartyPokemon	:	return "Level up with pokemon in party"
				case .levelUpMale			:	return "Level up (male)"
				case .levelUpFemale			:	return "Level up (female)"
				case .levelUpInMagneticField:	return "Level up near special magnetic field"
				case .levelUpAtMossRock		:	return "Level up near moss rock"
				case .levelUpAtIceRock		:	return "Level up near ice rock"
			}
		}
	}	
}

extension XGEvolutionMethods: XGEnumerable {
	var enumerableName: String {
		return string
	}

	var enumerableValue: String? {
		return rawValue.string
	}

	static var enumerableClassName: String {
		return "Evolution Methods"
	}

	static var allValues: [XGEvolutionMethods] {
		return allCases
	}
}















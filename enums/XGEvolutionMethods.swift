//
//  XGEvolutionMethods.swift
//  XG Tool
//
//  Created by StarsMmd on 29/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGEvolutionMethods : Int, Codable, CaseIterable {
	
	case none				= 0x00
	case maxHappiness		= 0x01
	case happinessDay		= 0x02
	case happinessNight		= 0x03
	case levelUp			= 0x04
	case trade				= 0x05
	case tradeWithItem		= 0x06
	case evolutionStone		= 0x07
	case moreAttack			= 0x08
	case equalAttack		= 0x09
	case moreDefense		= 0x0A
	case silcoon			= 0x0B
	case cascoon			= 0x0C
	case ninjask			= 0x0D
	case shedinja			= 0x0E
	case maxBeauty			= 0x0F
	case levelUpWithKeyItem	= 0x10
	case Gen4				= 0x11 // for eviolite
	
	var string : String {
		get {
			switch self {
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
				case .levelUpWithKeyItem	:	return "Level Up With Key Item"
				case .Gen4					:	return "Evolves in Generation 4 (XG)"
			}
		}
	}

	var conditionType: XGEvolutionConditionType {
		switch self {

		case .levelUp:
			fallthrough
		case .moreAttack:
			fallthrough
		case .equalAttack:
			fallthrough
		case .moreDefense:
			fallthrough
		case .silcoon:
			fallthrough
		case .cascoon:
			fallthrough
		case .ninjask:
			fallthrough
		case .shedinja:
			return .level

		case .tradeWithItem:
			fallthrough
		case .evolutionStone:
			fallthrough
		case .levelUpWithKeyItem:
			return .item

		default:
			return .none
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














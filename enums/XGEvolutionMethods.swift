//
//  XGEvolutionMethods.swift
//  XG Tool
//
//  Created by StarsMmd on 29/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGEvolutionMethods : Int, XGDictionaryRepresentable, Codable {
	
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
				case .Gen4					:	return "Evolves in Generation 4"
			}
		}
	}
	
	func cycle() -> XGEvolutionMethods {
		
		return XGEvolutionMethods(rawValue: self.rawValue + 1) ?? XGEvolutionMethods(rawValue: 0)!
		
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.string as AnyObject]
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case type, name
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.rawValue, forKey: .type)
		try container.encode(self.string, forKey: .name)
	}
}
















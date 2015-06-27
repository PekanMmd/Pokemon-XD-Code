//
//  XGEvolutionMethods.swift
//  XG Tool
//
//  Created by The Steez on 29/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGEvolutionMethods : Int {
	
	case None				= 0x00
	case MaxHappiness		= 0x01
	case HappinessDay		= 0x02
	case HappinessNight		= 0x03
	case LevelUp			= 0x04
	case Trade				= 0x05
	case TradeWithItem		= 0x06
	case EvolutionStone		= 0x07
	case MoreAttack			= 0x08
	case EqualAttack		= 0x09
	case MoreDefense		= 0x0A
	case Silcoon			= 0x0B
	case Cascoon			= 0x0C
	case Shedinja			= 0x0E
	case MaxBeauty			= 0x0F
	case LevelUpWithKeyItem	= 0x10
	
	var string : String {
		get {
			switch self {
				case .None					:	return "None"
				case .MaxHappiness			:	return "Max Happiness"
				case .HappinessDay			:	return "Happiness (Day)"
				case .HappinessNight		:	return "Happiness (Night)"
				case .LevelUp				:	return "Level Up"
				case .Trade					:	return "Trade"
				case .TradeWithItem			:	return "Trade With Item"
				case .EvolutionStone		:	return "Evolution Stone"
				case .MoreAttack			:	return "Atk > Def"
				case .EqualAttack			:	return "Atk = Def"
				case .MoreDefense			:	return "Atk < Def"
				case .Silcoon				:	return "Silcoon"
				case .Cascoon				:	return "Cascoon"
				case .Shedinja				:	return "Shedinja"
				case .MaxBeauty				:	return "Max Beauty"
				case .LevelUpWithKeyItem	:	return "Level Up With Key Item"
			}
		}
	}
	
	func cycle() -> XGEvolutionMethods {
		
		return XGEvolutionMethods(rawValue: self.rawValue + 1) ?? XGEvolutionMethods(rawValue: 0)!
		
	}
	
}
















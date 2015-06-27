//
//  XGMaps.swift
//  XG Tool
//
//  Created by The Steez on 01/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGMaps : String {
	
	case ShadowLab		= "D1"
	case MtBattle		= "D2"
	case SSLibra		= "D3"
	case RealgamTower	= "D4"
	case CipherKeyLair	= "D5"
	case CitadarkIsle	= "D6"
	case OrreColosseum	= "D7"
	case PhenacCity		= "M1"
	case PyriteTown		= "M2"
	case AgateVillage	= "M3"
	case PokemonHQ		= "M5"
	case GateonPort		= "M6"
	case OutskirtStand	= "S1"
	case SnagemHideout	= "S2"
	case KaminkosHouse	= "S3"
	
	var code : String {
		return self.rawValue
	}
	
	var name : String {
		switch self {
			
		case .ShadowLab		: return "Shadow Pokemon Lab"
		case .MtBattle		: return "Mt. Battle"
		case .SSLibra		: return "S.S. Libra"
		case .RealgamTower	: return "Realgam Tower"
		case .CipherKeyLair	: return "Cipher Key Lair"
		case .CitadarkIsle	: return "Citadark Isle"
		case .OrreColosseum	: return "Orre Colosseum"
		case .PhenacCity	: return "Phenac City"
		case .PyriteTown	: return "Pyrite Town"
		case .AgateVillage	: return "Agate Village"
		case .PokemonHQ		: return "Pokemon HQ Lab"
		case .GateonPort	: return "Gateon Port"
		case .OutskirtStand	: return "Outskirt Stand"
		case .SnagemHideout	: return "Team Snagem's Hideout"
		case .KaminkosHouse	: return "Kaminko's House"
			
		}
	}
	
}







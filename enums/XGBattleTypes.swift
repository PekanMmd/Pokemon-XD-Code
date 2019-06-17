//
//  XGBattleTypes.swift
//  GoD Tool
//
//  Created by The Steez on 24/08/2018.
//

import Foundation

enum XGBattleStyles : Int, Codable {
	
	case none = 0
	case single = 1
	case double = 2
	case other = 3
	
	var name: String {
		switch self {
		case .none:
			return "none"
		case .single:
			return "single"
		case .double:
			return "double"
		case .other:
			return "other"
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case type, name
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.rawValue, forKey: .type)
		try container.encode(self.name, forKey: .name)
	}
}

enum XGBattleTypes : Int, Codable {
	
	case none = 0
	case story_admin_colo = 1 // colosseum only
	case story = 2
	case colosseum_prelim = 3
	case sample = 4
	case colosseum_final = 5
	case colosseum_orre_prelim = 6
	case colosseum_orre_final = 7
	case mt_battle = 8
	case mt_battle_final = 9
	case battle_mode = 10
	case link_battle = 11
	case wild_pokemon = 12
	case battle_bingo = 13
	case battle_cd = 14
	case battle_training = 15
	case miror_b_pokespot = 16
	case battle_mode_mt_battle_colo = 17 // colosseum only
	
	var name : String {
		switch self {
			
		case .none:
			return "Invalid Battle Type"
		case .story_admin_colo:
			return "Admin Battle (colosseum)"
		case .story:
			return "Story Battle"
		case .colosseum_prelim:
			return "Colosseum Preliminary Round"
		case .colosseum_final:
			return "Colosseum Final Round"
		case .sample:
			return "Placeholder"
		case .colosseum_orre_prelim:
			return game == .XD ? "Orre Colosseum Preliminary Round" : "Colosseum Preliminary Round II"
		case .colosseum_orre_final:
			return game == .XD ? "Orre Colosseum Final Round" : "Colosseum Final Round II"
		case .mt_battle:
			return "Mt. Battle"
		case .mt_battle_final:
			return "Mt. Battle Final"
		case .battle_mode:
			return "Battle Mode"
		case .link_battle:
			return "Link Battle"
		case .wild_pokemon:
			return "Wild Pokémon"
		case .battle_bingo:
			return "Battle Bingo"
		case .battle_cd:
			return "Battle CD"
		case .battle_training:
			return "Battle Tutorial"
		case .miror_b_pokespot:
			return "Miror B. Pokespot"
		case .battle_mode_mt_battle_colo:
			return "Battle Mode Mt. Battle (colosseum)"
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case type, name
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.rawValue, forKey: .type)
		try container.encode(self.name, forKey: .name)
	}
}









//
//  XGBattleTypes.swift
//  GoD Tool
//
//  Created by The Steez on 24/08/2018.
//

import Foundation

enum XGBattleTypes: Int, Codable, CaseIterable {
	// These names are from the perspective of XD
	// Refer to the name variable below for names for colosseum
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
	case ecard_special_battle = 17 // colosseum only
	case battle_mode_mt_battle_final = 18 // colosseum only
	
	var name: String {
		switch self {
		case .none:
			return "None"
		case .story_admin_colo:
			return "Admin Battle"
		case .story:
			return "Story Battle"
		case .colosseum_prelim:
			return "Colosseum Preliminary Round"
		case .colosseum_final:
			return "Colosseum Final Round"
		case .sample:
			return "Test"
		case .colosseum_orre_prelim:
			return game == .XD ? "Orre Colosseum Preliminary Round" : "Phenac Colosseum Preliminary Round"
		case .colosseum_orre_final:
			return game == .XD ? "Orre Colosseum Final Round" : "Phenac Colosseum Final Round"
		case .mt_battle:
			return "Mt. Battle"
		case .mt_battle_final:
			return "Mt. Battle Final"
		case .battle_mode:
			return game == .XD ? "Battle Mode" : "E-Card Panel Battle"
		case .link_battle:
			return game == .XD ? "Link Battle" : "E-Card Endless Battle"
		case .wild_pokemon:
			return game == .XD ? "Wild Pokémon" : "Battle Mode Battle Now"
		case .battle_bingo:
			return game == .XD ? "Battle Bingo" : "Battle Mode Solo Colosseum"
		case .battle_cd:
			return game == .XD ? "Battle Bingo" : "Battle Mode Solo Colosseum Final"
		case .battle_training:
			return game == .XD ? "Battle Tutorial" : "Battle Mode Mt. Battle"
		case .miror_b_pokespot:
			return game == .XD ? "Miror B. Pokespot" : "Link Battle"
		case .ecard_special_battle:
			return "E-Card Special Battle"
		case .battle_mode_mt_battle_final:
			return "Battle Mode Mt. Battle Final"
		}
	}
}

extension XGBattleTypes: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Battle Types"
	}
	
	static var allValues: [XGBattleTypes] {
		return allCases
	}
}





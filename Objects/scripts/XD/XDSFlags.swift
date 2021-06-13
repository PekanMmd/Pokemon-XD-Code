//
//  XDSFlags.swift
//  GoDToolCL
//
//  Created by The Steez on 03/06/2018.
//

import Foundation

enum XDSFlags: Int, Codable, CaseIterable {

	case berryMasterVistied = 4
	case stepsWalkedSinceLastBerryMasterVisit = 5
	
	case story = 964
	
	case dayCareVisited = 1124

	case mirorBHasBeenEncountered = 1191

	case currentPokespotPokemonRock = 1248
	case currentPokespotPokemonOasis = 1249
	case currentPokespotPokemonCave = 1250
	
	
	case mirorbNoDespawn = 1415 // miror radar won't lost signal while this is set
	
	case MtBattleHighestClearedZone = 1433

	case mirorBStepsWalked = 1449
	
	case mirorbLocation = 1452
	
	case MtBattleCurrentZone = 1478
	
	case MtBattleCanBeChallenged = 1487
	
	case pyriteColosseumWins = 1754
	
	
	var name : String {
		switch self {
		case .story						: return "STORY"
		case .dayCareVisited			: return "DAY_CARE_VISITED"
		case .mirorbNoDespawn			: return "MIROR_RADAR_KEEP_SIGNAL_ON"
		case .mirorbLocation			: return "MIRORB_LOCATION"
		case .pyriteColosseumWins		: return "PYRITE_COLO_WINS"
		case .MtBattleHighestClearedZone	: return "MT_BATTLE_HIGHEST_CLEARED_ZONE"
		case .MtBattleCurrentZone		: return "MT_BATTLE_CURRENT_ZONE"
		case .MtBattleCanBeChallenged	: return "MT_BATTLE_CHALLENGE_AVAILABLE"
		case .currentPokespotPokemonRock: return "POKESPOT_ROCK_CURRENT_POKEMON"
		case .currentPokespotPokemonOasis: return "POKESPOT_OASIS_CURRENT_POKEMON"
		case .currentPokespotPokemonCave: return "POKESPOT_CAVE_CURRENT_POKEMON"
		case .berryMasterVistied		: return "BERRY_MASTER_VISITED"
		case .stepsWalkedSinceLastBerryMasterVisit : return "STEPS_SINCE_LAST_BERRY_MASTER_VISIT"
		case .mirorBHasBeenEncountered	: return "HAS_ENCOUNTERED_MIROR_B"
		case .mirorBStepsWalked			: return "MIROR_B_STEPS_WALKED"
		}
	}
}

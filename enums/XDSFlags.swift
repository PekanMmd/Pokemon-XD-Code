//
//  XDSFlags.swift
//  GoDToolCL
//
//  Created by The Steez on 03/06/2018.
//

import Foundation

enum XDSFlags : Int {
	
	case story = 964
	
	case mirorbNoDespawn = 1415 // miror radar won't lost signal while this is set
	case mirorbLocation = 1452
	
	case MtBattleCanBeChallenged = 1487
	
	case pyriteColosseumWins = 1754
	
	
	var name : String {
		switch self {
		case .story						: return "STORY"
		case .mirorbNoDespawn			: return "MIROR_RADAR_KEEP_SIGNAL_ON"
		case .mirorbLocation			: return "MIRORB_LOCATION"
		case .pyriteColosseumWins		: return "PYRITE_COLO_WINS"
		case .MtBattleCanBeChallenged	: return "MT_BATTLE_CHALLENGE_AVAILABLE"
		}
	}
}

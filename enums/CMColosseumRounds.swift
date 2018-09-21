//
//  CMColosseumRounds.swift
//  GoD Tool
//
//  Created by The Steez on 23/08/2018.
//

import Foundation

// values are possibly image ids for colosseum intro images
enum XGColosseumRounds : Int {
	case none = 0
	case special = 0x95
	case first = 0xd4
	case second = 0xd5
	case semifinal = 0xd7
	case final = 0xd6
	
	var name : String {
		switch self {
		case .none: return "none"
		case .first: return "Colosseum Round 1"
		case .second: return "Colosseum Round 2"
		case .semifinal: return "Colosseum Semifinal"
		case .final: return "Colosseum Final"
		case .special: return "Special Colosseum Battle"
		}
	}
}

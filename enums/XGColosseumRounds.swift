//
//  XGColosseumRound.swift
//  GoD Tool
//
//  Created by The Steez on 23/08/2018.
//

import Foundation

// values are possibly image ids for colosseum intro images
enum XGColosseumRounds : Int, Codable {
	case none = 0
	case first = 0x95
	case second = 0x96
	case semifinal = 0x9b
	case final = 0x9c
	
	var name : String {
		switch self {
			case .none: return "none"
			case .first: return "Colosseum Round 1"
			case .second: return "Colosseum Round 2"
			case .semifinal: return "Colosseum Semifinal"
			case .final: return "Colosseum Final"
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

//
//  XGColosseumRound.swift
//  GoD Tool
//
//  Created by The Steez on 23/08/2018.
//

import Foundation

// values are possibly image ids for colosseum intro images
enum XGColosseumRounds: Int, Codable, CaseIterable {
	#if GAME_XD
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
	#elseif GAME_COLO
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
	#endif
}

extension XGColosseumRounds: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Colosseum Rounds"
	}
	
	static var allValues: [XGColosseumRounds] {
		return allCases
	}
}

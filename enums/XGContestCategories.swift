//
//  XGContestCategories.swift
//  GoD Tool
//
//  Created by The Steez on 26/12/2018.
//

import Foundation

enum XGContestCategories: Int, Codable {
	case cool = 0
	case beauty
	case cute
	case smart
	case tough
	
	var name: String {
		switch self {
		case .cool:
			return "cool"
		case .beauty:
			return "beauty"
		case .cute:
			return "cute"
		case .smart:
			return "smart"
		case .tough:
			return "tough"
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

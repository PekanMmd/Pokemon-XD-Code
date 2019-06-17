//
//  XGDeoxysFormes.swift
//  GoDToolCL
//
//  Created by The Steez on 20/04/2018.
//

import Foundation

enum XGDeoxysFormes : Int, Codable {
	case normal  = 0
	case attack  = 1
	case defense = 2
	case speed   = 3
	
	var name : String {
		switch self {
			case .normal: return "Normal"
			case .attack: return "Attack"
			case .defense: return "Defense"
			case .speed: return "Speed"
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

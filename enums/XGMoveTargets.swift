//
//  MoveTargets.swift
//  Mausoleum Move Tool
//
//  Created by StarsMmd on 28/12/2014.
//  Copyright (c) 2014 StarsMmd. All rights reserved.
//

import Foundation

enum XGMoveTargets: Int, XGDictionaryRepresentable, Codable {
	
	case selectedTarget			= 0x00
	case dependsOnMove			= 0x01
	case allPokemon				= 0x02
	case random					= 0x03
	case bothFoes				= 0x04
	case user					= 0x05
	case bothFoesAndAlly		= 0x06
	case opponentField			= 0x07
	
	var string : String {
		get {
			switch self {
				case .selectedTarget	: return "Selected Target"
				case .dependsOnMove		: return "Depends On Move"
				case .allPokemon		: return "All Pokemon"
				case .random			: return "Random"
				case .bothFoes			: return "Both Foes"
				case .user				: return "User"
				case .bothFoesAndAlly	: return "Both Foes and Ally"
				case .opponentField		: return "Opponent's Feet"
			}
		}
	}
	
	func cycle() -> XGMoveTargets {
		
		return XGMoveTargets(rawValue: self.rawValue + 1) ?? XGMoveTargets(rawValue: 0)!
		
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.string as AnyObject]
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case type, name
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.rawValue, forKey: .type)
		try container.encode(self.string, forKey: .name)
	}
	
}




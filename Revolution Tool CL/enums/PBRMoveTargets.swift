//
//  PBRMoveTargets.swift
//  GoD Tool
//
//  Created by The Steez on 13/03/2019.
//

import Foundation

enum XGMoveTargets: Int, XGDictionaryRepresentable {
	
	case selectedTarget			= 0x00
	case dependsOnMove			= 0x01
	case random					= 0x02
	case bothFoes				= 0x04
	case bothFoesAndAlly		= 0x08
	case user					= 0x10
	case bothAllies				= 0x20
	case allPokemon				= 0x40
	case opponentField			= 0x80
	case ally 					= 0x100
	case userOrAlly				= 0x200
	case selectedFoe			= 0x400
	
	var string : String {
		get {
			switch self {
			case .selectedTarget		: return "Selected Target"
			case .dependsOnMove			: return "Depends On Move"
			case .allPokemon			: return "All Pokemon"
			case .random				: return "Random"
			case .bothFoes				: return "Both Foes"
			case .user					: return "User"
			case .bothFoesAndAlly		: return "Both Foes and Ally"
			case .opponentField			: return "Opponent's field"
			case .bothAllies			: return "Both Allies"
			case .ally					: return "Ally"
			case .userOrAlly			: return "User or Ally"
			case .selectedFoe			: return "Selected Foe"
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
	
}

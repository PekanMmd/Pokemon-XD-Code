//
//  MoveTargets.swift
//  Mausoleum Move Tool
//
//  Created by The Steez on 28/12/2014.
//  Copyright (c) 2014 Ovation International. All rights reserved.
//

import Foundation

enum XGMoveTargets: Int {
	
	case SelectedTarget			= 0x00
	case DependsOnMove			= 0x01
	case AllPokemon				= 0x02
	case Random					= 0x03
	case BothFoes				= 0x04
	case User					= 0x05
	case BothFoesAndAlly		= 0x06
	case OpponentField			= 0x07
	
	var string : String {
		get {
			switch self {
				case .SelectedTarget	: return "Selected Target"
				case .DependsOnMove		: return "Depends On Move"
				case .AllPokemon		: return "All Pokemon"
				case .Random			: return "Random"
				case .BothFoes			: return "Both Foes"
				case .User				: return "User"
				case .BothFoesAndAlly	: return "Both Foes and Ally"
				case .OpponentField		: return "Opponent's Feet"
			}
		}
	}
	
	func cycle() -> XGMoveTargets {
		
		return XGMoveTargets(rawValue: self.rawValue + 1) ?? XGMoveTargets(rawValue: 0)!
		
	}
	
}




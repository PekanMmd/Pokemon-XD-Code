//
//  XGBagSlots.swift
//  XG Tool
//
//  Created by The Steez on 19/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGBagSlots : Int {
	
	case None	    = 0x0
	case Pokeballs  = 0x1
	case Items		= 0x2
	case Berries    = 0x3
	case TMs		= 0x4
	case KeyItems	= 0x5
	case Colognes	= 0x6
	case BattleCDs	= 0x7
	
	var name : String {
		get {
			switch self {
				
				case .None		:	return "None"
				case .Pokeballs	:	return "Pokeballs"
				case .Items		:	return "Items"
				case .Berries	:	return "Berries"
				case .TMs		:	return "TMs"
				case .KeyItems	:	return "Key Items"
				case .Colognes	:	return "Colognes"
				case .BattleCDs	:	return "Battle CDs"
				
			}
		}
	}
	
	func cycle() -> XGBagSlots {
		
		return XGBagSlots(rawValue: self.rawValue + 1) ?? XGBagSlots(rawValue: 0)!
		
	}
	
}










//
//  XGEffectivenessValues.swift
//  XG Tool
//
//  Created by The Steez on 19/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGEffectivenessValues : Int {

	case Ineffective	   = 0x43
	case NotVeryEffective  = 0x42
	case Neutral		   = 0x3F
	case SuperEffective    = 0x41
	
	var string : String {
		get {
			switch self {
				case .Ineffective:			return "No Effect"
				case .NotVeryEffective:		return "Not Very Effective"
				case .Neutral:				return "Neutral Damage"
				case .SuperEffective:		return "Super Effective"
			}
		}
	}
	
	func cycle() -> XGEffectivenessValues {
		
		if self.rawValue == 0x43 {
			return XGEffectivenessValues(rawValue: 0x3F)!
		}
		
		var value = self.rawValue + 1
		
		while XGEffectivenessValues(rawValue: value) == nil { value++ }
		
		return XGEffectivenessValues(rawValue: value)!
		
	}
	
}








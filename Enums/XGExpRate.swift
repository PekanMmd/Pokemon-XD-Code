//
//  ExpIndex.swift
//  Mausoleum Stats Tool
//
//  Created by The Steez on 09/01/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGExpRate: Int {
	
	case Standard			= 0x0
	case VeryFast			= 0x1
	case Slowest			= 0x2
	case Slow				= 0x3
	case Fast				= 0x4
	case VerySlow			= 0x5
	
	var string : String {
		get {
			switch self {
				case .Standard:		return "Standard"
				case .VeryFast:		return "Very Fast"
				case .Slowest:		return "Slowest"
				case .Slow:			return "Slow"
				case .Fast:			return "Fast"
				case .VerySlow:		return "Very Slow"
			}
		}
		
	}
	
	func cycle() -> XGExpRate {
		
		return XGExpRate(rawValue: self.rawValue + 1) ?? XGExpRate(rawValue: 0)!
		
	}
	
}






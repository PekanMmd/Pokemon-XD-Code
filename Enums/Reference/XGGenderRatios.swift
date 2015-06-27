//
//  XGGenderRatios.swift
//  XG Tool
//
//  Created by The Steez on 30/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGGenderRatios : Int {
	
	case MaleOnly		= 0x00
	case Male87			= 0x1F
	case Male75			= 0x3F
	case Male50			= 0x7F
	case Female75		= 0xBF
	case Female87		= 0xDF
	case FemaleOnly		= 0xFE
	case Genderless		= 0xFF
	
	var string : String {
		get {
			switch self {
				case .MaleOnly:		return "Male Only"
				case .Male87:		return "87.5% Male"
				case .Male75:		return "75% Male"
				case .Male50:		return "50% Male"
				case .Female75:		return "75% Female"
				case .Female87:		return "87.5% Female"
				case .FemaleOnly:	return "Female Only"
				case .Genderless:	return "Genderless"
			}
			
		}
	}
	
	func cycle() -> XGGenderRatios {
		
		if self.rawValue == 0xFF {
			return XGGenderRatios(rawValue: 0)!
		}
		
		var value = self.rawValue + 1
		
		while XGGenderRatios(rawValue: value) == nil { value++ }
		
		return XGGenderRatios(rawValue: value)!
		
	}
	
}







//
//  Genders.swift
//  Mausoleum Tool
//
//  Created by The Steez on 11/01/2015.
//  Copyright (c) 2015 Steezy. All rights reserved.
//

import Foundation

enum XGGenders : Int {
	
	case Male		= 0x0
	case Female		= 0x1
	case Genderless = 0x2
	
	var string : String {
		get {
			switch self {
				case .Male:			return "Male"
				case .Female:		return "Female"
				case .Genderless:	return "Genderless"
			}
		}
	}
	
	func cycle() -> XGGenders {
		
		return XGGenders(rawValue: self.rawValue + 1) ?? XGGenders(rawValue: 0)!
		
	}
	
}





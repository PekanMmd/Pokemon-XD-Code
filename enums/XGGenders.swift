//
//  Genders.swift
//  Mausoleum Tool
//
//  Created by The Steez on 11/01/2015.
//  Copyright (c) 2015 Steezy. All rights reserved.
//

import Foundation

enum XGGenders : Int, XGDictionaryRepresentable {
	
	case male		= 0x0
	case female		= 0x1
	case genderless = 0x2
	
	var string : String {
		get {
			switch self {
				case .male:			return "Male"
				case .female:		return "Female"
				case .genderless:	return "Genderless"
			}
		}
	}
	
	func cycle() -> XGGenders {
		
		return XGGenders(rawValue: self.rawValue + 1) ?? XGGenders(rawValue: 0)!
		
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





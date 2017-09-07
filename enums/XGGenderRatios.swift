//
//  XGGenderRatios.swift
//  XG Tool
//
//  Created by The Steez on 30/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGGenderRatios : Int, XGDictionaryRepresentable {
	
	case maleOnly		= 0x00
	case male87			= 0x1F
	case male75			= 0x3F
	case male50			= 0x7F
	case female75		= 0xBF
	case female87		= 0xDF
	case femaleOnly		= 0xFE
	case genderless		= 0xFF
	
	var string : String {
		get {
			switch self {
				case .maleOnly:		return "Male Only"
				case .male87:		return "87.5% Male"
				case .male75:		return "75% Male"
				case .male50:		return "50% Male"
				case .female75:		return "75% Female"
				case .female87:		return "87.5% Female"
				case .femaleOnly:	return "Female Only"
				case .genderless:	return "Genderless"
			}
			
		}
	}
	
	func cycle() -> XGGenderRatios {
		
		if self.rawValue == 0xFF {
			return XGGenderRatios(rawValue: 0)!
		}
		
		var value = self.rawValue + 1
		
		while XGGenderRatios(rawValue: value) == nil { value += 1 }
		
		return XGGenderRatios(rawValue: value)!
		
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
	
	static func allRatios() -> [XGGenderRatios] {
		return [.maleOnly,.male87,.male75,.male50,.female75,.female87,.femaleOnly,.genderless]
	}
	
}







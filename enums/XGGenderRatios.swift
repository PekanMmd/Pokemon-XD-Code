//
//  XGGenderRatios.swift
//  XG Tool
//
//  Created by StarsMmd on 30/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGGenderRatios : Int, Codable, CaseIterable {
	
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
	
}

extension XGGenderRatios: XGEnumerable {
	var enumerableName: String {
		return string
	}
	
	var enumerableValue: String? {
		return rawValue.hexString()
	}
	
	static var className: String {
		return "Gender Ratios"
	}
	
	static var allValues: [XGGenderRatios] {
		return allCases
	}
}





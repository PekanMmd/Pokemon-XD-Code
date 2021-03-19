//
//  XGEffectivenessValues.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGEffectivenessValues: Int, Codable, CaseIterable {

	case ineffective		= 0x43
	case notVeryEffective	= 0x42
	case superEffective		= 0x41
	case missed				= 0x40
	case neutral			= 0x3F
	
	
	var string : String {
		get {
			switch self {
				case .ineffective:			return "No Effect"
				case .notVeryEffective:		return "Not Very Effective"
				case .neutral:				return "Neutral"
				case .superEffective:		return "Super Effective"
				case .missed:				return "Missed"
			}
		}
	}
	
	static func fromIndex(_ index: Int) -> XGEffectivenessValues {
		switch index {
		case 1:
			return .neutral
		case 2:
			return .notVeryEffective
		case 3:
			return .ineffective
		default:
			return .superEffective
		}
	}
	
	func cycle() -> XGEffectivenessValues {
		
		if self.rawValue == 0x43 {
			return XGEffectivenessValues(rawValue: 0x3F)!
		}
		
		var value = self.rawValue + 1
		
		while XGEffectivenessValues(rawValue: value) == nil { value += 1 }
		
		return XGEffectivenessValues(rawValue: value)!
		
	}
}

extension XGEffectivenessValues: XGEnumerable {
	var enumerableName: String {
		return string
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Effectiveness Values"
	}
	
	static var allValues: [XGEffectivenessValues] {
		return allCases
	}
}






//
//  XGEffectivenessValues.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGEffectivenessValues : Int, Codable, CaseIterable {

	case superEffective		= 0
	case neutral			= 1
	case notVeryEffective	= 2
	case ineffective		= 3
	case unknown1			= 4
	case unknown2			= 5

	var multiplier: Int {
		switch self {
		case .superEffective:
			return 20
		case .neutral:
			return 10
		case .notVeryEffective:
			return 5
		case .ineffective:
			return 0
		case .unknown1:
			return 10
		case .unknown2:
			return 10
		}
	}
	
	var string : String {
		get {
			switch self {
				case .ineffective:			return "No Effect"
				case .notVeryEffective:		return "Not Very Effective"
				case .neutral:				return "Neutral"
				case .superEffective:		return "Super Effective"
				case .unknown1:				return "Unknown 1"
				case .unknown2:				return "Unknown 2"
			}
		}
	}
	
	static func fromIndex(_ index: Int) -> XGEffectivenessValues {
		switch index {
		case 0:
			return .superEffective
		case 1:
			return .neutral
		case 2:
			return .notVeryEffective
		case 3:
			return .ineffective
		case 4:
			return .unknown1
		default:
			return .unknown2
		}
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







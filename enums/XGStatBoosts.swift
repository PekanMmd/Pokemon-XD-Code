//
//  XGStatBoosts.swift
//  GoD Tool
//
//  Created by The Steez on 11/10/2017.
//
//

import Foundation

enum XGStats : Int, Codable, CaseIterable {
	case attack = 1
	case defense = 2
	case speed = 3
	case special_attack = 4
	case special_defense = 5
	case accuracy = 6
	case evasion = 7
	
	var mask : Int {
		return Int(pow(2, Double(self.rawValue)))
	}
	
	static func maskForStats(stats: [XGStats]) -> Int {
		var mask = 0
		for stat in stats {
			mask = mask | stat.mask
		}
		return mask
	}
	
	var name: String {
		switch self {
		case .attack:
			return "attack"
		case .defense:
			return "defense"
		case .speed:
			return "speed"
		case .special_attack:
			return "special attack"
		case .special_defense:
			return "special defense"
		case .accuracy:
			return "accuracy"
		case .evasion:
			return "evasion"
		}
	}
}

enum XGStatModifiers : Int, Codable, CaseIterable {
	
	// legit
	case plus_1 = 0x10
	case plus_2 = 0x20
	
	// must be added through hax
	case plus_3 = 0x30
	case plus_4 = 0x40
	case plus_5 = 0x50
	case plus_6 = 0x60
	
	// legit
	case minus_1 = 0x90
	case minus_2 = 0xa0
	
	// must be added through hax
	case minus_3 = 0xb0
	case minus_4 = 0xc0
	case minus_5 = 0xd0
	case minus_6 = 0xe0
	
	var trueValue : Int {
		if self.rawValue < 0x90 {
			return self.rawValue / 0x10
		} else {
			return -((self.rawValue - 0x80) / 0x10)
		}
	}
}

enum XGStatStages: Int {
	case minus6 = 0, minus5, minus4, minus3, minus2, minus1
	case neutral
	case plus1, plus2, plus3, plus4, plus5, plus6
}


extension XGStats: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Stats"
	}
	
	static var allValues: [XGStats] {
		return allCases
	}
}




//
//  XGContestCategories.swift
//  GoD Tool
//
//  Created by The Steez on 26/12/2018.
//

import Foundation

enum XGContestCategories: Int, Codable, CaseIterable {
	case none = 0
	case cool
	case beauty
	case cute
	case smart
	case tough
	
	var name: String {
		switch self {
		case .none:
			return "None"
		case .cool:
			return "Cool"
		case .beauty:
			return "Beauty"
		case .cute:
			return "Cute"
		case .smart:
			return "Smart"
		case .tough:
			return "Tough"
		}
	}
	
}

extension XGContestCategories: XGEnumerable {
	var enumerableName: String {
		return name
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Contest Categories"
	}
	
	static var allValues: [XGContestCategories] {
		return allCases
	}
}

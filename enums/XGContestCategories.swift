//
//  XGContestCategories.swift
//  GoD Tool
//
//  Created by The Steez on 26/12/2018.
//

import Foundation

enum XGContestCategories: Int, Codable, CaseIterable {
	case cool = 0
	case beauty
	case cute
	case smart
	case tough
	
	var name: String {
		switch self {
		case .cool:
			return "cool"
		case .beauty:
			return "beauty"
		case .cute:
			return "cute"
		case .smart:
			return "smart"
		case .tough:
			return "tough"
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
	
	static var enumerableClassName: String {
		return "Contest Categories"
	}
	
	static var allValues: [XGContestCategories] {
		return allCases
	}
}

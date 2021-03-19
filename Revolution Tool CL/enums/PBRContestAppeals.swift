//
//  PBRContestAppeals.swift
//  GoD Tool
//
//  Created by The Steez on 13/03/2019.
//

import Foundation

enum XGContestAppeals: Int, CaseIterable {
	case cool = 0
	case beautiful = 1
	case cute = 2
	case clever = 3
	case tough = 4

	var name: String {
		switch self {
		case .cool:
			return "Cool"
		case .beautiful:
			return "Beautiful"
		case .cute:
			return "Cute"
		case .clever:
			return "Clever"
		case .tough:
			return "Tough"
		}
	}
}

extension XGContestAppeals: XGEnumerable {
	var enumerableName: String {
		name
	}

	var enumerableValue: String? {
		rawValue.string
	}

	static var className: String {
		"Contest Appeals"
	}

	static var allValues: [XGContestAppeals] {
		allCases
	}


}

//
//  XGTrainerContoller.swift
//  GoD Tool
//
//  Created by The Steez on 23/08/2018.
//

import Foundation

enum XGTrainerController: Int, Codable, CaseIterable {
	
	case AI = 0
	case P1 = 1
	case P2 = 2
	case P3 = 3
	case P4 = 4
	
	var string: String {
		switch self {
		case .AI:
			return "AI"
		case .P1:
			return "P1"
		case .P2:
			return "P2"
		case .P3:
			return "P3"
		case .P4:
			return "P4"
		}
	}
	
}

extension XGTrainerController: XGEnumerable {
	var enumerableName: String {
		return string
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var className: String {
		return "Trainer Controller"
	}
	
	static var allValues: [XGTrainerController] {
		return allCases
	}
	
	
}

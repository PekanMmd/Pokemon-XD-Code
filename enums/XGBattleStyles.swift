//
//  XGBattleStyles.swift
//  PBR Tool
//
//  Created by Stars Momodu on 17/07/2020.
//

import Foundation

enum XGBattleStyles : Int, Codable, CaseIterable {

	case none = 0
	case single = 1
	case double = 2
	case other = 3

	var name: String {
		switch self {
		case .none:
			return "none"
		case .single:
			return "single"
		case .double:
			return "double"
		case .other:
			return "other"
		}
	}
}

extension XGBattleStyles: XGEnumerable {
	var enumerableName: String {
		return name
	}

	var enumerableValue: String? {
		return rawValue.string
	}

	static var enumerableClassName: String {
		return "Battle Styles"
	}

	static var allValues: [XGBattleStyles] {
		return allCases
	}
}

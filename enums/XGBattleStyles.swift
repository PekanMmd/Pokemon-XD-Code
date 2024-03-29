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
			return "None"
		case .single:
			return "Single"
		case .double:
			return "Double"
		case .other:
			return game == .Colosseum ? "Multi" : "Other"
		}
	}

	#if GAME_COLO
	var valueFor6v6: Int {
		switch self {
		case .none:
			return 3
		case .single:
			return 0
		case .double:
			return 1
		case .other:
			return 2
		}
	}
	#endif
}

extension XGBattleStyles: XGEnumerable {
	var enumerableName: String {
		return name
	}

	var enumerableValue: String? {
		return rawValue.string
	}

	static var className: String {
		return "Battle Styles"
	}

	static var allValues: [XGBattleStyles] {
		return allCases
	}
}

//
//  XGEggGroups.swift
//  GoD Tool
//
//  Created by Stars Momodu on 28/03/2021.
//

import Foundation

enum XGEggGroups: Int, CaseIterable {
	case None = 0
	case Monster = 1
	case Water = 2
	case Bug = 3
	case Flying = 4
	case Field = 5
	case Fairy = 6
	case Grass = 7
	case Humanoid = 8
	case Water3 = 9
	case Mineral = 10
	case Amorphous = 11
	case Water2 = 12
	case Ditto = 13
	case Dragon = 14
	case Undiscovered = 15

	var name: String {
		switch self {
		case .None: return "None"
		case .Monster: return "Monster"
		case .Water: return "Water"
		case .Bug: return "Bug"
		case .Flying: return "Flying"
		case .Field: return "Field"
		case .Fairy: return "Fairy"
		case .Grass: return "Grass"
		case .Humanoid: return "Human-Like"
		case .Water3: return "Water 3"
		case .Mineral: return "Mineral"
		case .Amorphous: return "Amorphous"
		case .Water2: return "Water 2"
		case .Ditto: return "Ditto"
		case .Dragon: return "Dragon"
		case .Undiscovered: return "Undiscovered"
		}
	}
}

extension XGEggGroups: XGEnumerable {
	var enumerableName: String {
		return name
	}

	var enumerableValue: String? {
		return rawValue.string
	}

	static var className: String {
		return "Egg Groups"
	}

	static var allValues: [XGEggGroups] {
		return allCases
	}


}

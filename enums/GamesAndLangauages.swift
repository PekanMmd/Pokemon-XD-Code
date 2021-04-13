//
//  XGGenIIIGames.swift
//  GoD Tool
//
//  Created by Stars Momodu on 12/04/2021.
//

import Foundation

#if !GAME_PBR
enum GenIIIGames: Int {
	case none = 0
	case fireRed = 1
	case leafGreen = 2
	case sapphire = 8
	case ruby = 9
	case emerald = 10
	case colosseumXD = 11

	var name: String {
		switch self {
		case .none: return "None"
		case .fireRed: return "Fire Red"
		case .leafGreen: return "Leaf Green"
		case .sapphire: return "Sapphire"
		case .ruby: return "Ruby"
		case .emerald: return "Emerald"
		case .colosseumXD: return "Colosseum/XD"
		}
	}
}
#endif

enum XGLanguages : Int, Codable {

	case Japanese = 0
	case EnglishUK
	case EnglishUS
	case German
	case French
	case Italian
	case Spanish

	var name : String {
		switch self {
		case .Japanese: return "Japanese"
		case .EnglishUK: return "English (UK)"
		case .EnglishUS: return "English (US)"
		case .French: return "French"
		case .Spanish: return "Spanish"
		case .German: return "German"
		case .Italian: return "Italian"
		}
	}
}

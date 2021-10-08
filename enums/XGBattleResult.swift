//
//  XGBattleResult.swift
//  GoD Tool
//
//  Created by Stars Momodu on 08/10/2021.
//

import Foundation

enum XGBattleResult: Int, Codable {
	case none = 0, lost, won, tied, unknown1, unknown2

	var name: String {
		switch self {
		case .none: return "None"
		case .lost: return "Lost"
		case .won: return "Won"
		case .tied: return "Tied"
		case .unknown1: return "Unknown 1"
		case .unknown2: return "Unknown 2"
		}
	}
}

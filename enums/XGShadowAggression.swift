//
//  XGShadowAggression.swift
//  GoD Tool
//
//  Created by Stars Momodu on 11/10/2021.
//

import Foundation

enum XGShadowAggression: Int, Codable, CaseIterable {
	case none = 0, veryHigh, high, medium, low, veryLow

	var name: String {
		switch self {
		case .none: return "invalid"
		case .veryHigh: return "very high"
		case .high: return "high"
		case .medium: return "medium"
		case .low: return "low"
		case .veryLow: return "very low"
		}
	}

	var reverseModeChancePerBarsOpened: [Int] {
		guard let dol = XGFiles.dol.data,
			  self != .none else { return [0, 0, 0, 0, 0] }
		let tableOffset: Int
		switch  region  {
		case .US: tableOffset = 0x2f37a0
		case .EU: tableOffset = 0x2f25d0
		case .JP: tableOffset = 0x2ead40
		case .OtherGame: tableOffset = 0
		}
		var values = [Int]()
		for i in 0 ..< 5 {
			let offset = tableOffset - kDolTableToRAMOffsetDifference + (i * 5) + (rawValue - 1)
			values.append(dol.getByteAtOffset(offset))
		}
		return values
	}
}

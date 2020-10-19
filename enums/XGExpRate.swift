//
//  ExpIndex.swift
//  Mausoleum Stats Tool
//
//  Created by StarsMmd on 09/01/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

infix operator ^^
func ^^ (radix: Int, power: Int) -> Int {
	return Int(pow(Double(radix), Double(power)))
}

enum XGExpRate: Int, Codable, CaseIterable {
	
	case standard			= 0x0
	case veryFast			= 0x1
	case slowest			= 0x2
	case slow				= 0x3
	case fast				= 0x4
	case verySlow			= 0x5
	
	var string : String {
		get {
			switch self { // The comments show alternative names used by Bulbapedia etc.
				case .standard:		return "Standard" // medium fast
				case .veryFast:		return "Very Fast" // erratic
				case .slowest:		return "Slowest" // fluctuating
				case .slow:			return "Slow" // medium slow
				case .fast:			return "Fast" // fast
				case .verySlow:		return "Very Slow" // slow
			}
		}
		
	}
	
	var maxExp : Int {
		get {
			switch self {
				case .standard:		return 1_000_000
				case .veryFast:		return 600_000
				case .slowest:		return 1_640_000
				case .slow:			return 1_059_860
				case .fast:			return 800_000
				case .verySlow:		return 1_250_000
			}
		}
	}
	
	func expForLevel(_ level: Int) -> Int {
		switch self {
			case .standard:		return expForLevelStandard(level)
			case .veryFast:		return expForLevelVeryFast(level)
			case .slowest:		return expForLevelSlowest(level)
			case .slow:			return expForLevelSlow(level)
			case .fast:			return expForLevelFast(level)
			case .verySlow:		return expForLevelVerySlow(level)
		}
	}
	
	func expForLevelVeryFast(_ n: Int) -> Int {
		
		if n <= 50 {
			return (n^^3) * (100 - n) / 50
		} else if n <= 68 {
			return (n^^3) * (150 - n) / 100
		} else if n <= 98 {
			let m = Int( floor( ( 1911 - (10 * Float(n)) ) / 3 ) )
			return (n^^3) * m / 500
		} else {
			return (n^^3) * (160 - n) / 100
		}
	}
	
	func expForLevelFast(_ n: Int) -> Int {
		return 4 * (n^^3) / 5
	}
	
	func expForLevelStandard(_ n: Int) -> Int {
		return n^^3
	}
	
	func expForLevelSlow(_ n: Int) -> Int {
		return (6 * (n^^3) / 5) - (15 * (n^^2)) + (100 * n) - 140
	}
	
	func expForLevelVerySlow(_ n: Int) -> Int {
		return 5 * (n^^3) / 4
	}
	
	func expForLevelSlowest(_ n: Int) -> Int {
		
		if n <= 15 {
			let m = Int( floor( ( Float(n) + 1 ) / 3 ) )
			return (n^^3) * (m + 24) / 50
		} else if n <= 36 {
			return (n^^3) * (n + 14) / 50
		} else {
			let m = Int( floor( Float(n) / 2 ) )
			return (n^^3) * (m + 32) / 50
		}
	}
	
	func cycle() -> XGExpRate {
		
		return XGExpRate(rawValue: self.rawValue + 1) ?? XGExpRate(rawValue: 0)!
		
	}
	
}

extension XGExpRate: XGEnumerable {
	var enumerableName: String {
		return string
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var enumerableClassName: String {
		return "Experience Growth Rates"
	}
	
	static var allValues: [XGExpRate] {
		return allCases
	}
}





















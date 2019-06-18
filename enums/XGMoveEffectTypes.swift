//
//  XGMoveEffectTypes.swift
//  GoDToolCL
//
//  Created by The Steez on 06/05/2018.
//

import Foundation

enum XGMoveEffectTypes: Int, Codable, CaseIterable {
	
	case none			= 0x00
	case attack			= 0x01
	case healing		= 0x02
	case statNerf		= 0x03
	case statBuff		= 0x04
	case statusEffect	= 0x05
	case globalEffect	= 0x06
	case affectsMoves	= 0x07
	case OHKO			= 0x08
	case multiturn		= 0x09
	case misc			= 0x0a
	case misc2			= 0x0b
	case misc3			= 0x0c
	case misc4			= 0x0d
	case unknown		= 0x0e
	
	
	var string : String {
		get {
			switch self {
			case .none			: return "None"
			case .attack		: return "Attack"
			case .healing		: return "Healing"
			case .statNerf		: return "Stat Nerf"
			case .statBuff		: return "Stat Buff"
			case .statusEffect	: return "Status Effect"
			case .globalEffect	: return "Field Effect"
			case .affectsMoves	: return "Affects Incoming Move"
			case .OHKO			: return "OHKO"
			case .multiturn		: return "Multi-Turn"
			case .misc			: return "Misc"
			case .misc2			: return "Misc2"
			case .misc3			: return "Misc3"
			case .misc4			: return "Misc4"
			case .unknown		: return "Unknown"
			}
		}
	}
	
}

extension XGMoveEffectTypes: XGEnumerable {
	var enumerableName: String {
		return string
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var enumerableClassName: String {
		return "Move Effect types"
	}
	
	static var allValues: [XGMoveEffectTypes] {
		return allCases
	}
}

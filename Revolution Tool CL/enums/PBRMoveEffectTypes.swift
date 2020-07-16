//
//  XGMoveEffectTypes.swift
//  GoDToolCL
//
//  Created by The Steez on 06/05/2018.
//

import Foundation

enum XGMoveEffectTypes: Int, CaseIterable {
	
	case none				=  0
	case regularAttack		=  1
	case buff				=  2
	case fixedDamage		=  3
	case leechSeed			=  4
	case poison				=  5
	case paralyse			=  6
	case fissure			=  7
	case nightShade			=  8
	case variableMove		=  9
	case hiddenPower		= 10
	case psyWaveMirrorCoat  = 11
	case burn				= 12
	case weatherBall		= 13
	case nerf				= 14
	case itemBasedType		= 15
	case unknown			= 16
	
	var string : String {
		switch self {
		case .none				: return "None"
		case .regularAttack 	: return "Regular Attack"
		case .buff				: return "Buff"
		case .fixedDamage		: return "Fixed Damage"
		case .leechSeed			: return "Leech Seed"
		case .poison			: return "Poison"
		case .paralyse			: return "Paralyse"
		case .fissure			: return "Fissure"
		case .nightShade		: return "Night Shade"
		case .variableMove		: return "Variable Move"
		case .hiddenPower		: return "Hidden Power"
		case .psyWaveMirrorCoat	: return "Psywave/Mirror Coat"
		case .burn				: return "Burn"
		case .weatherBall		: return "Weather Ball"
		case .nerf				: return "Nerf"
		case .itemBasedType		: return "Item Based Type"
		case .unknown			: return "Unknown"
		}
	}
	
}

extension XGMoveEffectTypes: XGEnumerable, Equatable {
	var enumerableName: String {
		return string.spaceToLength(20)
	}

	var enumerableValue: String? {
		return rawValue.string
	}

	static var enumerableClassName: String {
		return "Move Effect Types"
	}

	static var allValues: [XGMoveEffectTypes] {
		return allCases
	}
}

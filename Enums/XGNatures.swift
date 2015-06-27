//
//  Nature.swift
//  Mausoleum Tool
//
//  Created by The Steez on 11/01/2015.
//  Copyright (c) 2015 Steezy. All rights reserved.
//

import Foundation

enum XGNatures : Int {
	
	case Hardy		= 0x00
	case Lonely		= 0x01
	case Brave		= 0x02
	case Adamant	= 0x03
	case Naughty	= 0x04
	
	case Bold		= 0x05
	case Docile		= 0x06
	case Relaxed	= 0x07
	case Impish		= 0x08
	case Lax		= 0x09
	
	case Timid		= 0x0A
	case Hasty		= 0x0B
	case Serious	= 0x0C
	case Jolly		= 0x0D
	case Naive		= 0x0E
	
	case Modest		= 0x0F
	case Mild		= 0x10
	case Quiet		= 0x11
	case Bashful	= 0x12
	case Rash		= 0x13
	
	case Calm		= 0x14
	case Gentle		= 0x15
	case Sassy		= 0x16
	case Careful	= 0x17
	case Quirky		= 0x18
	
	var string : String {
		get {
			switch self {
				case .Hardy		: return "Hardy"
				case .Lonely	: return "Lonely"
				case .Brave		: return "Brave"
				case .Adamant	: return "Adamant"
				case .Naughty	: return "Naughty"
				case .Bold		: return "Bold"
				case .Docile	: return "Docile"
				case .Relaxed	: return "Relaxed"
				case .Impish	: return "Impish"
				case .Lax		: return "Lax"
				case .Timid		: return "Timid"
				case .Hasty		: return "Hasty"
				case .Serious	: return "Serious"
				case .Jolly		: return "Jolly"
				case .Naive		: return "Naive"
				case .Modest	: return "Modest"
				case .Mild		: return "Mild"
				case .Quiet		: return "Quiet"
				case .Bashful	: return "Bashful"
				case .Rash		: return "Rash"
				case .Calm		: return "Calm"
				case .Gentle	: return "Gentle"
				case .Sassy		: return "Sassy"
				case .Careful	: return "Careful"
				case .Quirky	: return "Quirky"
			}
		}
	}
	
	func cycle() -> XGNatures {
		
		return XGNatures(rawValue: self.rawValue + 1) ?? XGNatures(rawValue: 0)!
		
	}
	
}








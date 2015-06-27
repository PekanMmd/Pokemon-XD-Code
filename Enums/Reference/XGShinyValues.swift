//
//  XGShinyValues.swift
//  XG Tool
//
//  Created by The Steez on 09/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGShinyValues : Int {
	
	case Never		= 0x0000
	case Always		= 0x0001
	case Random		= 0xFFFF
	
	var string : String {
		get {
			switch self {
				case .Never		: return "Never"
				case .Always	: return "Always"
				case .Random	: return "Random"
			}
		}
	}
	
	func cycle() -> XGShinyValues {
		switch self {
			case .Never		: return .Always
			case .Always	: return .Random
			case .Random	: return .Never
		}
	}
	
}











//
//  XGPokeSpots.swift
//  XG Tool
//
//  Created by The Steez on 08/06/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGPokeSpots : Int {
	
	case Rock		= 0x00
	case Oasis		= 0x01
	case Cave		= 0x02
	case All		= 0x03
	
	var string : String {
		get {
			switch self {
				case .Rock	: return "Rock"
				case .Oasis	: return "Oasis"
				case .Cave	: return "Cave"
				case .All	: return "All"
			}
		}
	}
	
}
//
//  XGMoveClass.swift
//  XG Tool
//
//  Created by The Steez on 19/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGMoveCategories : Int {
	
	case None	   = 0x0
	case Physical  = 0x1
	case Special   = 0x2
	
	var string : String {
		get {
			switch self {
				case .None:			return "Neither"
				case .Physical:		return "Physical"
				case .Special:		return "Special"
			}
		}
	}
	
	func cycle() -> XGMoveCategories {
		
		return XGMoveCategories(rawValue: self.rawValue + 1) ?? XGMoveCategories(rawValue: 0)!
		
	}
	
}





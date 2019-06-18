//
//  XGMoveClass.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGMoveCategories : Int {
	
	case physical  = 0x0
	case special   = 0x1
	case none	   = 0x2
	
	var string : String {
		get {
			switch self {
				case .none:			return "Status"
				case .physical:		return "Physical"
				case .special:		return "Special"
			}
		}
	}
	
	func cycle() -> XGMoveCategories {
		
		return XGMoveCategories(rawValue: self.rawValue + 1) ?? XGMoveCategories(rawValue: 0)!
		
	}
	
}





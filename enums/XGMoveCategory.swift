//
//  XGMoveClass.swift
//  XG Tool
//
//  Created by The Steez on 19/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGMoveCategories : Int, XGDictionaryRepresentable {
	
	case none	   = 0x0
	case physical  = 0x1
	case special   = 0x2
	
	var string : String {
		get {
			switch self {
				case .none:			return "Neither"
				case .physical:		return "Physical"
				case .special:		return "Special"
			}
		}
	}
	
	func cycle() -> XGMoveCategories {
		
		return XGMoveCategories(rawValue: self.rawValue + 1) ?? XGMoveCategories(rawValue: 0)!
		
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.string as AnyObject]
		}
	}
	
}





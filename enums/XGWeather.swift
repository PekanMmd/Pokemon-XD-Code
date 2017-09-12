//
//  XGWeather.swift
//  XG Tool
//
//  Created by StarsMmd on 20/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGWeather : Int, XGDictionaryRepresentable {
	
	case none	    = 0x0
	case sun		= 0x1
	case rain		= 0x2
	case sandstorm  = 0x3
	case hail		= 0x4
	case shadowSky	= 0x5
	
	var string : String {
		get {
			switch self {
				case .none		: return "None"
				case .sun		: return "Sun"
				case .rain		: return "Rain"
				case .sandstorm	: return "Sandstorm"
				case .hail		: return "Hail"
				case .shadowSky	: return "Shadow Sky"
			}
		}
	}
	
	func cycle() -> XGWeather {
		
		return XGWeather(rawValue: self.rawValue + 1) ?? XGWeather(rawValue: 0)!
		
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














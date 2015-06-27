//
//  XGWeather.swift
//  XG Tool
//
//  Created by The Steez on 20/05/2015.
//  Copyright (c) 2015 Ovation International. All rights reserved.
//

import Foundation

enum XGWeather : Int {
	
	case None	    = 0x0
	case Sun		= 0x1
	case Rain		= 0x2
	case Sandstorm  = 0x3
	case Hail		= 0x4
	case ShadowSky	= 0x5
	
	var string : String {
		get {
			switch self {
				case .None		: return "None"
				case .Sun		: return "Sun"
				case .Rain		: return "Rain"
				case .Sandstorm	: return "Sandstorm"
				case .Hail		: return "Hail"
				case .ShadowSky	: return "Shadow Sky"
			}
		}
	}
	
	func cycle() -> XGWeather {
		
		return XGWeather(rawValue: self.rawValue + 1) ?? XGWeather(rawValue: 0)!
		
	}
	
}














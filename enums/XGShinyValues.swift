//
//  XGShinyValues.swift
//  XG Tool
//
//  Created by StarsMmd on 09/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGShinyValues : Int, Codable, CaseIterable {
	
	case never		= 0x0000
	case always		= 0x0001
	case random		= 0xFFFF
	
	var string : String {
		get {
			switch self {
				case .never		: return "Never"
				case .always	: return "Always"
				case .random	: return "Random"
			}
		}
	}
	
	func cycle() -> XGShinyValues {
		switch self {
			case .never		: return .always
			case .always	: return .random
			case .random	: return .never
		}
	}
	
}

extension XGShinyValues: XGEnumerable {
	var enumerableName: String {
		return string
	}
	
	var enumerableValue: String? {
		return rawValue.string
	}
	
	static var enumerableClassName: String {
		return "Shiny Values"
	}
	
	static var allValues: [XGShinyValues] {
		return allCases
	}
}










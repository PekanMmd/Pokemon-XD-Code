//
//  XGShinyValues.swift
//  XG Tool
//
//  Created by StarsMmd on 09/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGShinyValues : Int, XGDictionaryRepresentable, Codable {
	
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
	
	enum CodingKeys: String, CodingKey {
		case type, name
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.rawValue, forKey: .type)
		try container.encode(self.string, forKey: .name)
	}
}











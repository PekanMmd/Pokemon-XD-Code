//
//  XGEffectivenessValues.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGEffectivenessValues : Int, XGDictionaryRepresentable, Codable {

	case ineffective		= 0x43
	case notVeryEffective	= 0x42
	case superEffective		= 0x41
	case missed				= 0x40
	case neutral			= 0x3F
	
	
	var string : String {
		get {
			switch self {
				case .ineffective:			return "No Effect"
				case .notVeryEffective:		return "Not Very Effective"
				case .neutral:				return "Neutral"
				case .superEffective:		return "Super Effective"
				case .missed:				return "Missed"
			}
		}
	}
	
	static func fromIndex(_ index: Int) -> XGEffectivenessValues {
		switch index {
		case 1:
			return .neutral
		case 2:
			return .notVeryEffective
		case 3:
			return .ineffective
		default:
			return .superEffective
		}
	}
	
	func cycle() -> XGEffectivenessValues {
		
		if self.rawValue == 0x43 {
			return XGEffectivenessValues(rawValue: 0x3F)!
		}
		
		var value = self.rawValue + 1
		
		while XGEffectivenessValues(rawValue: value) == nil { value += 1 }
		
		return XGEffectivenessValues(rawValue: value)!
		
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








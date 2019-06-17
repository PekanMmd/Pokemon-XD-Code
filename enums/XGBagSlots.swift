//
//  XGBagSlots.swift
//  XG Tool
//
//  Created by StarsMmd on 19/05/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kNumberOfBagSlots = game == .Colosseum ? 7 : 8

enum XGBagSlots : Int, CustomStringConvertible, XGDictionaryRepresentable, Codable {
	
	case none	    = 0x0
	case pokeballs  = 0x1
	case items		= 0x2
	case berries    = 0x3
	case tms		= 0x4
	case keyItems	= 0x5
	case colognes	= 0x6
	case battleCDs	= 0x7
	
	var name : String {
		get {
			switch self {
				
				case .none		:	return "None"
				case .pokeballs	:	return "Pokeballs"
				case .items		:	return "Items"
				case .berries	:	return "Berries"
				case .tms		:	return "TMs"
				case .keyItems	:	return "Key Items"
				case .colognes	:	return "Colognes"
				case .battleCDs	:	return "Battle CDs"
				
			}
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.name as AnyObject]
		}
	}
	
	func cycle() -> XGBagSlots {
		
		return XGBagSlots(rawValue: self.rawValue + 1) ?? XGBagSlots(rawValue: 0)!
		
	}
	
	var description : String {
		get {
			return self.name
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case type, name
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.rawValue, forKey: .type)
		try container.encode(self.name, forKey: .name)
	}
}










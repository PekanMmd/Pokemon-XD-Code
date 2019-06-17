//
//  XGBattleBingoPanel.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

enum XGBattleBingoPanel : CustomStringConvertible, XGDictionaryRepresentable {
	
	case mysteryPanel(XGBattleBingoItem)
	case pokemon(XGBattleBingoPokemon)
	
	var pokemon : XGBattleBingoPokemon? {
		get {
			switch self {
			case .pokemon(let p): return p
			default: return nil
			}
		}
	}
	
	var description : String {
		get {
			switch self {
				case .mysteryPanel(let b)	: return "\(b)"
				case .pokemon(let p)		: return "\(p)"
			}
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			switch self {
			case .mysteryPanel(let item):
				return ["Mystery panel" : item.dictionaryRepresentation as AnyObject]
			case .pokemon(let pokemon) :
				return ["Pokemon panel" : pokemon.dictionaryRepresentation as AnyObject]
			}
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			switch self {
			case .mysteryPanel(let item):
				return item.readableDictionaryRepresentation
			case .pokemon(let pokemon) :
				return pokemon.readableDictionaryRepresentation
			}
		}	}
	
}

enum XGBattleBingoItem : Int, CustomStringConvertible, XGDictionaryRepresentable, Codable {
	
	case masterBall = 0x1
	case ePx1		= 0x2
	case ePx2		= 0x3
	
	var name : String {
		get {
			switch self {
				case .masterBall	: return "Master Ball"
				case .ePx1			: return "EP x1"
				case .ePx2			: return "EP x2"
			}
		}
	}
	
	var description : String {
		get {
			return self.name
		}
	}
	
	var dictionaryRepresentation: [String : AnyObject] {
		get {
			return ["Value" : self.rawValue as AnyObject]
		}
	}
	
	var readableDictionaryRepresentation: [String : AnyObject] {
		get {
			return ["mystery panel" : self.name as AnyObject]
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

extension XGBattleBingoPanel: Codable {
	enum XGBattleBingoPanelDecodingError: Error {
		case invalidPanelType(key: String)
	}
	
	enum CodingKeys: String, CodingKey {
		case type, value
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)
		switch type {
		case "mystery":
			let item = try container.decode(XGBattleBingoItem.self, forKey: .value)
			self = .mysteryPanel(item)
		case "pokemon":
			let pokemon = try container.decode(XGBattleBingoPokemon.self, forKey: .value)
			self = .pokemon(pokemon)
		default:
			throw XGBattleBingoPanelDecodingError.invalidPanelType(key: type)
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
			
		case .mysteryPanel(let item):
			try container.encode("mystery", forKey: .type)
			try container.encode(item, forKey: .value)
		case .pokemon(let pokemon):
			try container.encode("pokemon", forKey: .type)
			try container.encode(pokemon, forKey: .value)
		}
	}
}






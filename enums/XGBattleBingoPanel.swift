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

enum XGBattleBingoItem : Int, CustomStringConvertible, XGDictionaryRepresentable {
	
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
	
}








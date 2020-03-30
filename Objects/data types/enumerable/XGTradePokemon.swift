//
//  XGTradePokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

let kElekidOffset			= 0x1C57A4
let kMedititeOffset			= 0x1C5888
let kShuckleOffset			= 0x1C58D8
let kLarvitarOffset			= 0x1C5928

let kTradePokemonSpeciesOffset		=  0x02
let kTradePokemonLevelOffset		=  0x0B
let kTradePokemonMove1Offset		=  0x26
let kTradePokemonMove2Offset		=  0x2A
let kTradePokemonMove3Offset		=  0x2E
let kTradePokemonMove4Offset		=  0x32

final class XGTradePokemon: NSObject, XGGiftPokemon, Codable {
	
	@objc var index			= 0
	
	@objc var level			= 0x0
	var species			= XGPokemon.pokemon(0)
	var move1			= XGMoves.move(0)
	var move2			= XGMoves.move(0)
	var move3			= XGMoves.move(0)
	var move4			= XGMoves.move(0)
	
	@objc var giftType		= "Duking Trade"
	private(set) var gender	= XGGenders.random
	private(set) var nature	= XGNatures.random
	
	// unused
	@objc var exp				= -1
	var shinyValue		= XGShinyValues.random
	
	@objc var startOffset : Int {
		get {
			switch index {
				case 0 : return kElekidOffset
				case 1 : return kMedititeOffset
				case 2 : return kShuckleOffset
				default: return kLarvitarOffset
			}
		}
	}
	
	@objc init(index: Int) {
		super.init()
		
		let dol			= XGFiles.dol.data!
		self.index		= index
		
		if index == 0 {
			self.giftType = "Hordel Trade"
		}
		
		let start = startOffset
		
		let species = dol.get2BytesAtOffset(start + kTradePokemonSpeciesOffset)
		self.species = .pokemon(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove1Offset)
		move1 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove2Offset)
		move2 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove3Offset)
		move3 = .move(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove4Offset)
		move4 = .move(moveIndex)
		
		level = dol.getByteAtOffset(start + kTradePokemonLevelOffset)
		
		
	}
	
	@objc func save() {
		
		let dol = XGFiles.dol.data!
		let start = startOffset
		
		dol.replaceByteAtOffset(start + kTradePokemonLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kTradePokemonSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove4Offset, withBytes: move4.index)
		
		
		dol.save()
	}
	
}

extension XGTradePokemon: XGEnumerable {
	var enumerableName: String {
		return species.name.string
	}
	
	var enumerableValue: String? {
		return String(format: "%03d", index)
	}
	
	static var enumerableClassName: String {
		return "Trades"
	}
	
	static var allValues: [XGTradePokemon] {
		var values = [XGTradePokemon]()
		for i in 0 ... 3 {
			values.append(XGTradePokemon(index: i))
		}
		return values
	}
}

extension XGTradePokemon: XGDocumentable {
	
	static var documentableClassName: String {
		return "Trade Pokemon"
	}
	
	var documentableName: String {
		return (enumerableValue ?? "") + " - " + enumerableName
	}
	
	static var DocumentableKeys: [String] {
		return ["index", "name", "level", "gender", "nature", "shininess", "moves"]
	}
	
	func documentableValue(for key: String) -> String {
		switch key {
		case "index":
			return index.string
		case "name":
			return species.name.string
		case "level":
			return level.string
		case "gender":
			return gender.string
		case "nature":
			return nature.string
		case "shininess":
			return shinyValue.string
		case "moves":
			var text = ""
			text += "\n" + move1.name.string
			text += "\n" + move2.name.string
			text += "\n" + move3.name.string
			text += "\n" + move4.name.string
			return text
		default:
			return ""
		}
	}
}















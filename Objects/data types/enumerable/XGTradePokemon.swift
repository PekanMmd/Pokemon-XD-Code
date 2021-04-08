//
//  XGTradePokemon.swift
//  XG Tool
//
//  Created by StarsMmd on 11/06/2015.
//  Copyright (c) 2015 StarsMmd. All rights reserved.
//

import Foundation

var kElekidOffset: Int {
	switch region {
	case .US: return 0x1C57A4
	case .JP: return 0x1C0CB4
	case .EU: return 0x1C70A0
	case .OtherGame: return 0
	}
}
var kMedititeOffset: Int {
	switch region {
	case .US: return 0x1C5888
	case .JP: return 0x1C0D1C
	case .EU: return 0x1C7184
	case .OtherGame: return 0
	}
}
var kShuckleOffset: Int {
	switch region {
	case .US: return 0x1C58D8
	case .JP: return 0x1C0D6C
	case .EU: return 0x1C71D4
	case .OtherGame: return 0
	}
}
var kLarvitarOffset: Int {
	switch region {
	case .US: return 0x1C5928
	case .JP: return 0x1C0DBC
	case .EU: return 0x1C7224
	case .OtherGame: return 0
	}
}

let kTradePokemonSpeciesOffset		=  0x02
let kTradePokemonLevelOffset		=  0x0B
let kTradePokemonMove1Offset		=  0x26
let kTradePokemonMove2Offset		=  0x2A
let kTradePokemonMove3Offset		=  0x2E
let kTradePokemonMove4Offset		=  0x32

var giftPokemonShininessRAMOffset: Int {
	switch region {
	case .US: return 0x152c1a
	case .EU: return 0x1544de
	case .JP: return 0x14df42
	case .OtherGame: return 0
	}
}

final class XGTradePokemon: NSObject, XGGiftPokemon, GoDCodable {
	
	var index			= 0
	
	var level			= 0x0
	var species			= XGPokemon.index(0)
	var move1			= XGMoves.index(0)
	var move2			= XGMoves.index(0)
	var move3			= XGMoves.index(0)
	var move4			= XGMoves.index(0)
	
	var giftType		= "Duking Trade"
	private(set) var gender	= XGGenders.random
	private(set) var nature	= XGNatures.random
	
	// unused
	var exp				= -1
	var shinyValue		= XGShinyValues.random
	
	var startOffset : Int {
		get {
			switch index {
				case 0 : return kElekidOffset
				case 1 : return kMedititeOffset
				case 2 : return kShuckleOffset
				default: return kLarvitarOffset
			}
		}
	}
	
	init(index: Int) {
		super.init()
		
		let dol			= XGFiles.dol.data!
		self.index		= index
		
		if index == 0 {
			self.giftType = "Hordel Trade"
		}
		
		let start = startOffset
		
		let species = dol.get2BytesAtOffset(start + kTradePokemonSpeciesOffset)
		self.species = .index(species)
		
		var moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove1Offset)
		move1 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove2Offset)
		move2 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove3Offset)
		move3 = .index(moveIndex)
		moveIndex = dol.get2BytesAtOffset(start + kTradePokemonMove4Offset)
		move4 = .index(moveIndex)
		
		level = dol.getByteAtOffset(start + kTradePokemonLevelOffset)
		
		shinyValue = XGShinyValues(rawValue:  dol.get2BytesAtOffset(giftPokemonShininessRAMOffset - kDolToRAMOffsetDifference)) ?? .random
	}
	
	func save() {
		
		let dol = XGFiles.dol.data!
		let start = startOffset
		
		dol.replaceByteAtOffset(start + kTradePokemonLevelOffset, withByte: level)
		dol.replace2BytesAtOffset(start + kTradePokemonSpeciesOffset, withBytes: species.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove1Offset, withBytes: move1.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove2Offset, withBytes: move2.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove3Offset, withBytes: move3.index)
		dol.replace2BytesAtOffset(start + kTradePokemonMove4Offset, withBytes: move4.index)

		dol.replace2BytesAtOffset(giftPokemonShininessRAMOffset - kDolToRAMOffsetDifference, withBytes: shinyValue.rawValue)
		
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
	
	static var className: String {
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














